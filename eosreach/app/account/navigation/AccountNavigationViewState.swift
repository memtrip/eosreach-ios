import Foundation

enum AccountNavigationViewState: MxViewState {
    case idle
    case onProgress
    case onSuccess(accountList: [AccountEntity])
    case onError
    case noAccounts
    case navigateToAccount(accountEntity: AccountEntity)
}
