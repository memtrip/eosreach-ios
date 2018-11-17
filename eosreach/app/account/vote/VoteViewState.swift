import Foundation

enum VoteViewState: MxViewState {
    case idle
    case populateProxyVote(proxyAccountName: String)
    case populateProducerVotes(eosAccountVote: EosAccountVote)
    case noVoteCast
    case navigateToCastProducerVote
    case navigateToCastProxyVote
    case navigateToViewProducer(accountName: String)
    case navigateToViewProxyVote(accountName: String)
    case onVoteForUsProgress
    case onVoteForUsSuccess
    case onVoteForUsError(message: String, log: String)
}
