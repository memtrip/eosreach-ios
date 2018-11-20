import Foundation

enum SearchResult: MxResult {
    case idle
    case onProgress
    case onError
    case onSuccess(accountModel: AccountModel)
    case viewAccount(accountModel: AccountModel)
}
