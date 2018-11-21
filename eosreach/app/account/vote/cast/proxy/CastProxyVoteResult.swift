import Foundation

enum CastProxyVoteResult: MxResult {
    case idle
    case onProgress
    case onGenericError
    case onSuccess
    case viewLog(log: String)
    case navigateToExploreProxies
}
