import Foundation

enum VoteIntent: MxIntent {
    case idle
    case start(eosAccountVote: EosAccountVote?)
    case voteForUs(eosAccount: EosAccount)
    case navigateToCastProducerVote
    case navigateToCastProxyVote
    case navigateToViewProducer(accountName: String)
    case navigateToViewProxy(accountName: String)
}
