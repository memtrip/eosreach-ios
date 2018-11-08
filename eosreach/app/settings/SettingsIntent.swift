import Foundation

enum SettingsIntent: MxIntent {
    case start
    case idle
    case navigateToCurrencyPairing
    case navigateToEosEndpoint
    case navigateToPrivateKeys
    case navigateToViewConfirmedTransactions
    case navigateToTelegram
    case requestClearDataAndLogout
    case confirmClearDataAndLogout
    case navigateToAuthor
}
