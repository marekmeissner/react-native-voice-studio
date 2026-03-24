package com.voicestudio

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule

import java.io.File

import android.net.Uri

@ReactModule(name = VoiceStudioModule.NAME)
class VoiceStudioModule(
  reactContext: ReactApplicationContext
) : NativeVoiceStudioModuleSpec(reactContext) {
  private val moduleImpl = VoiceStudioModuleImpl(reactContext)

  private var promiseBlock: Promise? = null

  override fun getName() = VoiceStudioModuleImpl.NAME

  init {
    VoiceStudioModuleImpl.listener = object : VoiceStudioModuleImpl.VoiceStudioModuleListener {
      override fun onSuccess(uri: Uri?, outputFile: File?) {

        promiseBlock?.resolve(true)
        promiseBlock = null

        if (uri != null && outputFile != null) {
          outputFile.inputStream().use { sourceInputStream ->
            uri?.let {
              reactContext.contentResolver.openOutputStream(it)?.use { outputStream ->
                sourceInputStream.copyTo(outputStream)
              }
            }
          }
        }
      }

      override fun onError(error: Exception) {
        promiseBlock?.reject("E_RECORDING_ERROR", error.message, error)
        promiseBlock = null
      }
    }
  }

  override fun startRecording(promise: Promise) {
    promiseBlock = promise
    moduleImpl.startRecordingSession()
  }

  override fun stopRecording() {
    moduleImpl.stopRecordingSession()
  }

  override fun openSettings() {
    moduleImpl.openSettings()
  }

  companion object {
    const val NAME = VoiceStudioModuleImpl.NAME
  }
}
