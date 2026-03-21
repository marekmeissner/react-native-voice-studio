import AVFAudio
import UIKit
import os.log

@objc(VoiceStudioModuleDelegate)
public protocol VoiceStudioModuleDelegate: AnyObject {
  func onError(_ error: Error)
  func onSuccess()
}

@objc(VoiceStudioModuleImpl)
public class VoiceStudioModuleImpl: NSObject {
  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "VoiceStudio",
    category: "VoiceStudio")
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
      logger.error("AudioSession setup failed: \(error.localizedDescription)")
      delegate?.onError(VoiceStudioModuleError.unexpectedError)
    }
  }

  private func setupRecorder() {
    guard let url = getRecordingURL() else { return }
    recordingURL = url

    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 1,
      AVEncoderBitRateKey: 128000,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
      audioRecorder = try AVAudioRecorder(url: url, settings: settings)
      audioRecorder?.record()
      delegate?.onSuccess()
    } catch {
      logger.error("SetupRecorder failed: \(error.localizedDescription)")
      delegate?.onError(VoiceStudioModuleError.unexpectedError)
    }
  }

  @objc public func stopRecordingSession() {
    audioRecorder?.stop()
    audioRecorder = nil

    guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController else {
      logger.error("No rootViewController available")
      return
    }

    self.presentSaveDialog(from: rootVC)
  }

  @objc public func openAppSettings() {
    let url = URL(string: UIApplication.openSettingsURLString)
    if UIApplication.shared.canOpenURL(url!) {
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
  }

  private func presentSaveDialog(from viewController: UIViewController) {
    guard let url = recordingURL else {
      logger.error("File URL not found")
      return
    }

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

extension VoiceStudioModuleImpl: UIDocumentPickerDelegate {
  public func documentPicker(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
  ) {
    guard let destinationURL = urls.first else {
      logger.error("No destination URL selected")
      return
    }

    logger.debug("User selected destination: \(destinationURL.path)")
    controller.delegate = nil
  }

  public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    logger.warning("Document Picker was cancelled")
    controller.delegate = nil
  }
}
