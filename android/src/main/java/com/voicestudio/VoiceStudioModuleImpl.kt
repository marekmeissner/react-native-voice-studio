package com.voicestudio

import com.facebook.react.bridge.ReactApplicationContext

class VoiceStudioModuleImpl(private val reactContext: ReactApplicationContext) {
  fun handleRecording(message: String) {
    print(message);
  }

  companion object {
    const val NAME = "VoiceStudio"
  }
}
