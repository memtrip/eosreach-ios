import Foundation

enum CurrencyPairingResult: MxResult {
    case idle
    case onProgress
    case onError(message: String)
    case onSuccess
}
