import Foundation

enum CastProxyVoteViewState: MxViewState {
    case idle
    case onProgress
    case onGenericError
    case onLogError(log: String)
    case onSuccess
    case viewLog(log: String)
    case navigateToExploreProxies
}
