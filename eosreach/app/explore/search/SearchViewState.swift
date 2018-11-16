import Foundation

enum SearchViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case onSuccess(accountEntity: AccountEntity)
    case viewAccount(accountEntity: AccountEntity)
}
