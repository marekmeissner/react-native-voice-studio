import UIKit
import AVFAudio

@objc(VoiceStudioModuleImpl)
public class VoiceStudioModuleImpl: NSObject {

  @objc public func startRecording() {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
      if granted {
        print("Permission granted")
      } else {
        print("Permission to record audio was denied.")
      }
    }
  }

  @objc public func stopRecording() {
    print("Recording stopped")
  }
}
