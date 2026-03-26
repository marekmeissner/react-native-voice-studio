# 🎙️ React Native Voice Studio

A lightweight **React Native TurboModule** for handling audio recording with native performance.

---

## ✨ Features

- Start and stop audio recording
- Saves recording to place of your choice in documents
- Native TurboModule
- Simple API surface
- Handles permission & system settings redirection 

---


## 📦 Installation

```bash
npm install react-native-voice-studio
# or
yarn add react-native-voice-studio
```

Then install pods (iOS):

```bash
cd ios && pod install
```

---

## ⚙️ Android Setup (IMPORTANT)

You **must** register the activity launcher in your `MainActivity`.

### Step 1: Open `MainActivity.kt`

```kotlin
import android.os.Bundle; 
import com.voicestudio.VoiceStudioModuleImpl
...
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    VoiceStudioModuleImpl.registerActivityLauncher(this)
}
```

### 💡 Why is this required?

The module needs access to the current `Activity` to:

- Launch system UI flows (e.g. permissions, document picker)
- Handle results from Android activity-based APIs

Without this:
- Permission flows may fail ❌
- Document picker may not work ❌
- You may encounter unexpected crashes ❌

---

## 🍎 iOS Setup (Audio Recording)

To enable audio recording on iOS, you need to configure permissions and audio session properly.

---

### Step 1: Add Microphone Permission

Open your `Info.plist` and add:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to your microphone to record audio.</string>
```

### 💡 Why is this required?

iOS enforces strict privacy rules. Without this key:

- The app will crash immediately when trying to access the microphone ❌
- The permission dialog will not appear ❌

---

### ⚠️ Important Notes

- If the user denies permission permanently:
  - You must guide them to Settings
  - `openSettings()` method will handle this

---

## 📘 API

### Methods

#### `startRecording()`

```ts
startRecording(): Promise<void>
```

Starts audio recording.

- Requests permission if needed
- Throws error if permission is denied

---

#### `stopRecording()`

```ts
stopRecording(): void
```

Stops the current recording session.

---

#### `openSettings()`

```ts
openSettings(): void
```

Opens the app settings page.

---

## 🚨 Errors

```ts
export enum VoiceStudioError {
  PERMISSION_DENIED = 'PERMISSION_DENIED',
  UNEXPECTED_ERROR = 'UNEXPECTED_ERROR',
}
```

---

### Error Handling Example

```ts
import VoiceStudio, { VoiceStudioError } from 'react-native-voice-studio';

try {
  await VoiceStudio.startRecording();
} catch (e) {
  if (e === VoiceStudioError.PERMISSION_DENIED) {
    VoiceStudio.openSettings();
    console.log('Permission denied');
  }
}
```

---

## 🧠 Usage Example

```ts
import VoiceStudio from 'react-native-voice-studio';

const start = async () => {
  try {
    await VoiceStudio.startRecording();
    console.log('Recording started');
  } catch (e) {
    console.error(e);
  }
};

const stop = () => {
  VoiceStudio.stopRecording();
  console.log('Recording stopped');
};
```

---

## 🔐 Permissions

### Android

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

---

## 📱 Demos

### 🍎 iOS

https://github.com/user-attachments/assets/071d5d9e-2021-43b3-80c4-c83d977a089b

### 🤖 Android

https://github.com/user-attachments/assets/9f037ee0-5b33-49de-8e7c-64dae7818040

---

## 🐛 Troubleshooting

### Recording doesn’t start

- Check microphone permission
- Ensure `registerActivityLauncher` is added (Android)

### App crashes on startRecording

- Missing permission keys (Android/iOS)
- Module not linked properly

---

## 📄 License

MIT
