enum VoiceStudioModuleError: Error {
    case permissionDenied
    case audioSessionError
    case recorderSetupError
    case documentPickerCancelled
    case noRootViewController
}

extension VoiceStudioModuleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "PERMISSION_DENIED"
        case .audioSessionError:
            return "AUDIO_SESSION_ERROR"
        case .recorderSetupError:
            return "RECORDER_SETUP_ERROR"
        case .documentPickerCancelled:
            return "DOCUMENT_PICKER_CANCELLED"
        case .noRootViewController:
            return "NO_ROOT_VIEW_CONTROLLER"
        }
    }
}