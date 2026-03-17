require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "VoiceStudio"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/marekmeissner/react-native-voice-studio.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift,cpp}"
  s.private_header_files = "ios/**/*.h"

  s.frameworks = "AVFAudio"

      s.pod_target_xcconfig = {
      "DEFINES_MODULE" => "YES",
      "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "VoiceStudio-Swift.h",
    }

  install_modules_dependencies(s)
end
