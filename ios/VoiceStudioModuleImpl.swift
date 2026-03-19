import UIKit
import AVFAudio

@objc(VoiceStudioModuleDelegate)
public protocol VoiceStudioModuleDelegate: AnyObject {
    func onError(_ error: Error)
    func onSuccess()
}

@objc(VoiceStudioModuleImpl)
public class VoiceStudioModuleImpl: NSObject {
  @objc public weak var delegate: VoiceStudioModuleDelegate?
  private var audioRecorder: AVAudioRecorder?
  private var recordingURL: URL?
  
  @objc public func startRecordingSession() {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.record, mode: .default)
      try audioSession.setActive(true)
      
      audioSession.requestRecordPermission { granted in
        if granted {
          self.setupRecorder()
        } else {
          self.delegate?.onError(VoiceStudioModuleError.permissionDenied)
        }
      }
    } catch {
      delegate?.onError(VoiceStudioModuleError.unexpectedError)
    }
  }

  private func setupRecorder() {
    guard let url = getRecordingURL() else { return }
    recordingURL = url

    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: url, settings: settings)
      audioRecorder?.record()
      delegate?.onSuccess()
    } catch {
      delegate?.onError(VoiceStudioModuleError.unexpectedError)
    }
  }

  @objc public func stopRecordingSession() {
    audioRecorder?.stop()
    audioRecorder = nil
    
    if let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController {
      presentSaveDialog(from: rootVC)
    }
  }

  @objc public func openAppSettings () {
    let url = URL(string:UIApplication.openSettingsURLString)
    if UIApplication.shared.canOpenURL(url!){
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
  }
  
  private func presentSaveDialog(from viewController: UIViewController) {
    guard let url = recordingURL else { return }
    let picker = UIDocumentPickerViewController(urls: [url], in: .exportToService)
    picker.delegate = self
    viewController.present(picker, animated: true, completion: nil)
  }

  private func getRecordingURL() -> URL? {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"

    let fileName = "\(formatter.string(from: Date())).m4a"

    let recordingURL = documentsPath.appendingPathComponent(fileName)
    
    return recordingURL
  }
}

extension VoiceStudioModuleImpl : UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        delegate?.onSuccess()
        controller.delegate = nil
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.onError(VoiceStudioModuleError.documentPickerCancelled)
        controller.delegate = nil
    }
}