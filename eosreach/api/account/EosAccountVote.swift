import Foundation

struct EosAccountVote {
    let proxyVoterAccountName: String
    let producers: [String]
    let staked: Double
    let lastVoteWeight: String
    let proxiedVoteWeight: String
    let isProxyVoter: Bool
    let hasDelegatedProxyVoter: Bool
}
