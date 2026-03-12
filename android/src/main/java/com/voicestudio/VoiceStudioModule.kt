package com.voicestudio

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = VoiceStudioModule.NAME)
class VoiceStudioModule(
  // Each native module class consumes react application context
  reactContext: ReactApplicationContext
): NativeVoiceStudioModuleSpec(reactContext) {
  private val moduleImpl = VoiceStudioModuleImpl(reactContext)

  override fun getName() = VoiceStudioModuleImpl.NAME

  override fun startRecording() {
    moduleImpl.handleRecording("Start recording");
  }

  override fun stopRecording() {
    moduleImpl.handleRecording("Stop recording")
  }

  companion object {
    const val NAME = VoiceStudioModuleImpl.NAME
  }
}
