enum VoiceStudioModuleError: Error {
    case permissionDenied
    case documentPickerCancelled
    case unexpectedError
}

extension VoiceStudioModuleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "PERMISSION_DENIED"
        case .unexpectedError:
            return "UNEXPECTED_ERROR"
        }
    }
}
