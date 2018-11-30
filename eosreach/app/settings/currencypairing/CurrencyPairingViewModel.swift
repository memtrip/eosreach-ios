import Foundation
import RxSwift

class CurrencyPairingViewModel: MxViewModel<CurrencyPairingIntent, CurrencyPairingResult, CurrencyPairingViewState> {

    private let eosPriceUseCase = EosPriceUseCase()
    
    override func dispatcher(intent: CurrencyPairingIntent) -> Observable<CurrencyPairingResult> {
        switch intent {
        case .idle:
            return just(CurrencyPairingResult.idle)
        case .currencyPair(let currencyPair):
            return checkCurrencyPair(currencyCode: currencyPair)
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
        case .onSuccess(let symbol):
            return CurrencyPairingViewState.onSuccess(symbol: symbol)
        }
    }
    
    private func checkCurrencyPair(currencyCode: String) -> Observable<CurrencyPairingResult> {
        if (currencyCode.isEmpty || currencyCode.count < 3) {
            return just(CurrencyPairingResult.onError(message: R.string.settingsStrings.settings_currency_pairing_error_too_short()))
        } else {
            return eosPriceUseCase.refreshPrice(currencyCode: currencyCode).map { eosPrice in
                if (eosPrice.unavailable) {
                    return CurrencyPairingResult.onError(message: R.string.settingsStrings.settings_currency_pairing_error_generic(currencyCode))
                } else {
                    return CurrencyPairingResult.onSuccess(symbol: eosPrice.currency)
                }
            }.catchErrorJustReturn(CurrencyPairingResult.onError(
                message: R.string.settingsStrings.settings_currency_pairing_error_generic(currencyCode)))
                .asObservable().startWith(CurrencyPairingResult.onProgress)
        }
    }
}
