import UIKit

@objc(VoiceStudioModuleImpl)
public class VoiceStudioModuleImpl: NSObject {

  @objc public func startRecording() {
    print("Started Recording")
  }

  @objc public func stopRecording() {
    print("Stopped Recording")
  }
}
