package com.voicestudio

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.UiThreadUtil

import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

import android.media.MediaRecorder
import android.Manifest
import android.content.pm.PackageManager
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.util.Log

import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class VoiceStudioModuleImpl(private val reactContext: ReactApplicationContext) {
  private var audioRecorder: MediaRecorder? = null
  private var isFirstTimeRequest: Boolean = true
  private var currentOutputFile: File? = null

  interface VoiceStudioModuleListener {
    fun onSuccess()
    fun onError(error: Exception)
  }

  fun startRecordingSession() {
    val activity = reactContext.currentActivity ?: run {
      Log.e(NAME, "Failed to fetch current activity")
      listener?.onError(Exception("UNEXPECTED_ERROR"))
      return
    }

    if (isRecordPermissionGranted()) {
      val file = getRecordingFile()

      audioRecorder = MediaRecorder().apply {
        setAudioSource(MediaRecorder.AudioSource.MIC)
        setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        setOutputFile(file.absolutePath)
        setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
        setAudioSamplingRate(44100)
        setAudioEncodingBitRate(128000)
        setAudioChannels(1)
        prepare()
        start()
      }

      listener?.onSuccess();
    } else {

      ActivityCompat.shouldShowRequestPermissionRationale(
        activity,
        Manifest.permission.RECORD_AUDIO
      ).let { shouldShow ->
        if (isFirstTimeRequest || shouldShow) {
          ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            REQUEST_RECORD_AUDIO
          )

          isFirstTimeRequest = false
        } else {
          listener?.onError(Exception("PERMISSION_DENIED"))
        }
      }
    }
  }

  fun stopRecordingSession() {
    try {
      audioRecorder?.stop()
      audioRecorder?.release()
      audioRecorder = null

      val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
        addCategory(Intent.CATEGORY_OPENABLE)
        type = "audio/m4a"
        putExtra(Intent.EXTRA_TITLE, currentOutputFile?.name ?: "recording.m4a")
      }

      UiThreadUtil.runOnUiThread {
        reactContext.currentActivity?.startActivityForResult(intent, REQUEST_CREATE_FILE)
      }
    } catch (e: Exception) {
      Log.e(NAME, "stopRecordingSession failed", e)
    }
  }

  fun openSettings() {
    reactContext.currentActivity?.let { activity ->
      val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
        data = Uri.fromParts("package", reactContext.packageName, null)
      }

      activity.startActivity(intent)
    }
  }

  private fun isRecordPermissionGranted(): Boolean {
    return ContextCompat.checkSelfPermission(
      reactContext,
      Manifest.permission.RECORD_AUDIO
    ) == PackageManager.PERMISSION_GRANTED
  }

  private fun setupRecorder() {
    try {
      val file = getRecordingFile()

      audioRecorder = MediaRecorder().apply {
        setAudioSource(MediaRecorder.AudioSource.MIC)
        setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        setOutputFile(file.absolutePath)
        setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
        setAudioSamplingRate(44100)
        setAudioEncodingBitRate(128000)
        setAudioChannels(1)
        prepare()
        start()
      }

      listener?.onSuccess()
    } catch (e: Exception) {
      Log.e(NAME, "Failed to setup recorder", e)

      audioRecorder?.release()
      audioRecorder = null
    }
  }

  private fun getRecordingFile(): File {
    val formatter = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault())
    val fileName = "${formatter.format(Date())}.m4a"


    val dir = File(reactContext.getExternalFilesDir(null), NAME)

    if (!dir.exists()) {
      dir.mkdirs()
    }

    val file = File(dir, fileName)
    currentOutputFile = file
    return file
  }

  companion object {
    private const val REQUEST_RECORD_AUDIO = 1001
    private const val REQUEST_CREATE_FILE = 1002
    const val NAME = "VoiceStudio"

    var listener: VoiceStudioModuleListener? = null
  }
}
