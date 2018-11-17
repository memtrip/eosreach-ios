import Foundation

enum AccountNavigationResult: MxResult {
    case idle
    case onProgress
    case onSuccess(accountList: [AccountEntity])
    case onError
    case navigateToAccount(accountEntity: AccountEntity)
    case noAccounts
}
