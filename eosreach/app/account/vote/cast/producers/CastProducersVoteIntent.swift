import Foundation

enum CastProducersVoteIntent: MxIntent {
    case idle
    case start(eosAccountVote: EosAccountVote?)
    case vote(voterAccountName: String, blockProducers: [String])
    case addProducerField(producerName: String)
    case addProducerFromList
}
