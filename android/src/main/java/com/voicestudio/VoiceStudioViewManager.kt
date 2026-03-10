package com.voicestudio

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.VoiceStudioViewManagerInterface
import com.facebook.react.viewmanagers.VoiceStudioViewManagerDelegate

@ReactModule(name = VoiceStudioViewManager.NAME)
class VoiceStudioViewManager : SimpleViewManager<VoiceStudioView>(),
  VoiceStudioViewManagerInterface<VoiceStudioView> {
  private val mDelegate: ViewManagerDelegate<VoiceStudioView>

  init {
    mDelegate = VoiceStudioViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<VoiceStudioView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): VoiceStudioView {
    return VoiceStudioView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: VoiceStudioView?, color: Int?) {
    view?.setBackgroundColor(color ?: Color.TRANSPARENT)
  }

  companion object {
    const val NAME = "VoiceStudioView"
  }
}
