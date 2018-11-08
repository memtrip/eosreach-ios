import Foundation

enum EosEndpointResult: MxResult {
    case idle
    case onProgress
    case onError(message: String)
    case onSuccess
    case navigateToBlockProducerList
}
