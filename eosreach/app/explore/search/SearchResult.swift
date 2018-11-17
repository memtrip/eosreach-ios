import Foundation

enum SearchResult: MxResult {
    case idle
    case onProgress
    case onError
    case onSuccess(accountCardModel: AccountCardModel)
    case viewAccount(accountCardModel: AccountCardModel)
}
