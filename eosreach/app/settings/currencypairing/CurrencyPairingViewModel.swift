import Foundation
import RxSwift

class CurrencyPairingViewModel: MxViewModel<CurrencyPairingIntent, CurrencyPairingResult, CurrencyPairingViewState> {

    override func dispatcher(intent: CurrencyPairingIntent) -> Observable<CurrencyPairingResult> {
        switch intent {
        case .idle:
            return just(CurrencyPairingResult.idle)
        case .currencyPair(let currencyPair):
            return just(CurrencyPairingResult.onProgress)
        }
    }

    override func reducer(previousState: CurrencyPairingViewState, result: CurrencyPairingResult) -> CurrencyPairingViewState {
        switch result {
        case .idle:
            return CurrencyPairingViewState.idle
        case .onProgress:
            return CurrencyPairingViewState.onProgress
        case .onError(let message):
            return CurrencyPairingViewState.onError(message: message)
        case .onSuccess:
            return CurrencyPairingViewState.onSuccess
        }
    }
}
