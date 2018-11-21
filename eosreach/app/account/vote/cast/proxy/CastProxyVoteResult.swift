import Foundation

enum CastProxyVoteResult: MxResult {
    case idle
    case onProgress
    case onGenericError
    case onLogError(log: String)
    case onSuccess
    case viewLog(log: String)
    case navigateToExploreProxies
}
