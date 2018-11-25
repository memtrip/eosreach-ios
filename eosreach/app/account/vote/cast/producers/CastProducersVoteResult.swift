import Foundation

enum CastProducersVoteResult: MxResult {
    case idle
    case onProgress
    case addProducerFromList
    case addExistingProducers(producers: [String])
    case addProducerField
    case onGenericError
    case onSuccess
    case viewLog(log: String)
}
