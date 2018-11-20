import Foundation

enum EosEndpointResult: MxResult {
    case idle
    case onProgress
    case onErrorInvalidUrl
    case onErrorNothingChanged
    case onErrorGeneric
    case onSuccess(url: String)
    case navigateToBlockProducerList
}
