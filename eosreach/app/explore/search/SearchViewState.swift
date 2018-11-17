import Foundation

enum SearchViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case onSuccess(accountCardModel: AccountCardModel)
    case viewAccount(accountCardModel: AccountCardModel)
}
