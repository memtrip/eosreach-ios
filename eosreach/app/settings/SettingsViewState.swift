import Foundation

enum SettingsViewState: MxViewState {
    case idle
    case populate(exchangeRateCurrency: String)
    case navigateToCurrencyPairing
    case navigateToEosEndpoint
    case navigateToPrivateKeys
    case navigateToViewConfirmedTransactions
    case navigateToTelegram
    case confirmClearData
    case navigateToEntry
    case navigateToAuthor
}
