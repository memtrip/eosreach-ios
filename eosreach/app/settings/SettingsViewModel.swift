import Foundation
import RxSwift

class SettingsViewModel: MxViewModel<SettingsIntent, SettingsResult, SettingsViewState> {

    private let eosPriceCurrencyPair = EosPriceCurrencyPair()
    private let dropDb = DropDb()
    
    override func dispatcher(intent: SettingsIntent) -> Observable<SettingsResult> {
        switch intent {
        case .start:
            return just(SettingsResult.populate(exchangeRateCurrency: eosPriceCurrencyPair.get()))
        case .idle:
            return just(SettingsResult.idle)
        case .navigateToCurrencyPairing:
            return just(SettingsResult.navigateToCurrencyPairing)
        case .navigateToEosEndpoint:
            return just(SettingsResult.navigateToEosEndpoint)
        case .navigateToPrivateKeys:
            return just(SettingsResult.navigateToPrivateKeys)
        case .navigateToViewConfirmedTransactions:
            return just(SettingsResult.navigateToViewConfirmedTransactions)
        case .navigateToTelegram:
            return just(SettingsResult.navigateToTelegram)
        case .requestClearDataAndLogout:
            return just(SettingsResult.confirmClearData)
        case .confirmClearDataAndLogout:
            return clearData()
        case .navigateToAuthor:
            return just(SettingsResult.navigateToAuthor)
        }
    }

    override func reducer(previousState: SettingsViewState, result: SettingsResult) -> SettingsViewState {
        switch result {
        case .idle:
            return SettingsViewState.idle
        case .populate(let exchangeRateCurrency):
            return SettingsViewState.populate(exchangeRateCurrency: exchangeRateCurrency)
        case .navigateToCurrencyPairing:
            return SettingsViewState.navigateToCurrencyPairing
        case .navigateToEosEndpoint:
            return SettingsViewState.navigateToEosEndpoint
        case .navigateToPrivateKeys:
            return SettingsViewState.navigateToPrivateKeys
        case .navigateToViewConfirmedTransactions:
            return SettingsViewState.navigateToViewConfirmedTransactions
        case .navigateToTelegram:
            return SettingsViewState.navigateToTelegram
        case .confirmClearData:
            return SettingsViewState.confirmClearData
        case .navigateToEntry:
            return SettingsViewState.navigateToEntry
        case .navigateToAuthor:
            return SettingsViewState.navigateToAuthor
        }
    }
    
    private func clearData() -> Observable<SettingsResult> {
        return dropDb.drop()
            .andThen(Single.just(SettingsResult.navigateToEntry))
            .asObservable()
    }
}
