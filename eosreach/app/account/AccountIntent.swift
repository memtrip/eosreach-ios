import Foundation

enum AccountIntent: MxIntent {
    case idle
    case start(accountBundle: AccountBundle, page: AccountPage)
    case balanceTabIdle
    case resourceTabIdle
    case voteTabIdle
    case retry(accountBundle: AccountBundle)
    case refresh(accountBundle: AccountBundle)
    case openNavigation
    case navigateToExplore
    case navigateToImportKey
    case navigateToCreateAccount
    case navigateToSettings
}
