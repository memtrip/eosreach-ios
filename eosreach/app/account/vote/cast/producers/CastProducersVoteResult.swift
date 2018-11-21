import Foundation

enum CastProducersVoteResult: MxResult {
    case idle
    case onProgress
    case addExistingProducers(producers: [String])
    case addProducerField(nextPosition: Int)
    case removeProducerField(position: Int)
    case insertProducerField(nextPosition: Int, producerName: String)
    case onGenericError
    case onSuccess
    case viewLog(log: String)
}
