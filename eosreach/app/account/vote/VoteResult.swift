import Foundation

enum VoteResult: MxResult {
    case idle
    case populateProxyVote(proxyAccountName: String)
    case populateProducerVotes(eosAccountVote: EosAccountVote)
    case noVoteCast
    case navigateToCastProducerVote
    case navigateToCastProxyVote
    case navigateToViewProducer(accountName: String)
    case navigateToViewProxyVote(accountName: String)
    case onVoteForUsProgress
    case onVoteForUsError(message: String, log: String)
    case onVoteForUsSuccess
}
