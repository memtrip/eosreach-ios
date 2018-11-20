import Foundation

enum SearchViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case onSuccess(accountModel: AccountModel)
    case viewAccount(accountModel: AccountModel)
}
