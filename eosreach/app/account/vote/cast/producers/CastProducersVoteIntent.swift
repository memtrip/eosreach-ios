import Foundation

enum CastProducersVoteIntent: MxIntent {
    case idle
    case start(eosAccountVote: EosAccountVote?)
    case vote(voterAccountName: String, blockProducers: [String])
    case addProducerField(nextPosition: Int, currentTotal: Int)
    case insertProducerField(nextPosition: Int, currentTotal: Int, producerName: String)
    case removeProducerField(removePosition: Int)
    case viewLog(log: String)
}
