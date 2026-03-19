import { useCallback, useState } from 'react';
import { View, StyleSheet, Pressable, Text } from 'react-native';
import { VoiceStudio, VoiceStudioError } from 'react-native-voice-studio';

export default function App() {
  const [isRecording, setIsRecording] = useState(false);

  const onStartRecording = useCallback(async () => {
    try {
      await VoiceStudio.startRecording();
      setIsRecording(true);
    } catch (error) {
      if (
        error instanceof Error &&
        error.message === VoiceStudioError.PERMISSION_DENIED
      ) {
        VoiceStudio.openSettings();
      } else {
        console.log(
          'An unexpected error occurred while starting the recording.'
        );
      }
    }
  }, []);

  const onStopRecording = useCallback(() => {
    console.log('Recording stopped');
    VoiceStudio.stopRecording();
    setIsRecording(false);
  }, []);

  return (
    <View style={styles.container}>
      {!isRecording ? (
        <Pressable
          style={[styles.button, styles.notRecordingButton]}
          onPress={onStartRecording}
        >
          <Text style={styles.buttonText}>Start Recording</Text>
        </Pressable>
      ) : (
        <Pressable
          style={[styles.button, styles.recordingButton]}
          onPress={onStopRecording}
        >
          <Text style={styles.buttonText}>Stop Recording</Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    height: 60,
    backgroundColor: '#eee',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
    borderRadius: 8,
  },
  buttonText: {
    fontSize: 18,
    color: 'white',
    fontWeight: 'bold',
  },
  recordingButton: {
    backgroundColor: 'red',
  },
  notRecordingButton: {
    backgroundColor: 'green',
  },
});
