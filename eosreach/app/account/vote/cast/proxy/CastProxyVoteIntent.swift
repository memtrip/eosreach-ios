import Foundation

enum CastProxyVoteIntent: MxIntent {
    case idle
    case vote(voterAccountName: String, proxyAccountName: String)
    case viewLog(log: String)
    case navigateToExploreProxies()
}
