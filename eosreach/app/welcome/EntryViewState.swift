import Foundation

enum EntryViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case onRsaEncryptionFailed
    case navigateToSplash
    case navigateToAccount(account: String)
}
