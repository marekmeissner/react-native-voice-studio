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
        case .documentPickerCancelled:
            return "DOCUMENT_PICKER_CANCELLED"
        case .unexpectedError:
            return "UNEXPECTED_ERROR"
        }
    }
}
