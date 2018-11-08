import Foundation

enum EosEndpointIntent: MxIntent {
    case idle
    case changeEndpoint(endpoint: String)
    case navigateToBlockProducerList
}
