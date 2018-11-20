import Foundation

enum AccountNavigationIntent: MxIntent {
    case idle
    case start
    case accountSelected(accountName: String)
    case refreshAccounts
    case navigateToImportKey
    case navigateToCreateAccount
    case navigateToSettings
}
