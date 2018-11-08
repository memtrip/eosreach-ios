import Foundation

enum EosEndpointViewState: MxViewState {
    case idle
    case onProgress
    case onError(message: String)
    case onSuccess
    case navigateToBlockProducerList
}
