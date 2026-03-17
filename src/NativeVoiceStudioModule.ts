import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export type StartRecordingError =
  | 'PERMISSION_DENIED'
  | 'AUDIO_SESSION_ERROR'
  | 'RECORDER_SETUP_ERROR'
  | 'DOCUMENT_PICKER_CANCELLED'
  | 'NO_ROOT_VIEW_CONTROLLER';

export interface Spec extends TurboModule {
  startRecording(): Promise<void>;
  stopRecording(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('VoiceStudio');
