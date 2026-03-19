import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export enum VoiceStudioError {
  PERMISSION_DENIED = 'PERMISSION_DENIED',
  DOCUMENT_PICKER_CANCELLED = 'DOCUMENT_PICKER_CANCELLED',
  UNEXPECTED_ERROR = 'UNEXPECTED_ERROR',
}

export interface Spec extends TurboModule {
  startRecording(): Promise<void>;
  stopRecording(): void;
  openSettings(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('VoiceStudio');
