import Foundation

enum CastProxyVoteViewState: MxViewState {
    case idle
    case onProgress
    case onGenericError
    case onSuccess
    case viewLog(log: String)
    case navigateToExploreProxies
}
