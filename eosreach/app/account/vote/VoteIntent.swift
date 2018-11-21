import Foundation

enum VoteIntent: MxIntent {
    case idle
    case start(eosAccountVote: EosAccountVote?)
    case voteForUs(accountName: String)
    case navigateToCastProducerVote
    case navigateToCastProxyVote
    case navigateToViewProducer(accountName: String)
    case navigateToViewProxy(accountName: String)
}
