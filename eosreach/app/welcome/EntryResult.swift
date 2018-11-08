import Foundation

enum EntryResult: MxResult {
    case idle
    case onProgress
    case onError
    case onRsaEncryptionFailed
    case navigateToSplash
    case navigateToAccount(account: String)
}
