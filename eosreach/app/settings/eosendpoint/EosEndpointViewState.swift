import Foundation


struct EosEndpointViewState: MxViewState, Copy, Equatable {
    var endpointUrl: String
    var view: View

    static func == (lhs: EosEndpointViewState, rhs: EosEndpointViewState) -> Bool {
        return lhs.endpointUrl == rhs.endpointUrl
            && lhs.view == rhs.view
    }

    enum View : Equatable {
        case idle
        case onProgress
        case onErrorInvalidUrl
        case onErrorNothingChanged
        case onErrorGeneric
        case onSuccess
        case navigateToBlockProducerList
    }
}
