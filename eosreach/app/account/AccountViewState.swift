import Foundation

struct AccountViewState: MxViewState {
    let view: View
    let accountName: String? = nil
    let accountView: AccountView? = nil
    
    enum View {
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
}
