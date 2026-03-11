import { View, StyleSheet, Pressable, Text } from 'react-native';
import { VoiceStudio } from 'react-native-voice-studio';

export default function App() {
  return (
    <View style={styles.container}>
      <Pressable
        style={styles.box}
        onPress={() => VoiceStudio.startRecording()}
      >
        <Text>Press me</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
