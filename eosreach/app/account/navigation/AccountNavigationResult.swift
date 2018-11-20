import Foundation

enum AccountNavigationResult: MxResult {
    case idle
    case onProgress
    case onSuccess(accountModelList: [AccountModel])
    case onError
    case navigateToAccount(accountName: String)
    case noAccounts
    case navigateToImportKey
    case navigateToCreateAccount
    case navigateToSettings
}
