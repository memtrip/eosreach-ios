import Foundation

enum CurrencyPairingViewState: MxViewState {
    case idle
    case onProgress
    case onError(message: String)
    case onSuccess(symbol: String)
}
