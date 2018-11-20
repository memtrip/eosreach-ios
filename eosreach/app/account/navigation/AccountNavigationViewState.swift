import Foundation

enum AccountNavigationViewState: MxViewState {
    case idle
    case onProgress
    case onSuccess(accountList: [AccountModel])
    case onError
    case noAccounts
    case navigateToAccount(accountName: String)
    case navigateToImportKey
    case navigateToCreateAccount
    case navigateToSettings
}
