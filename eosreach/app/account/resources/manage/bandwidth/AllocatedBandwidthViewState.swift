import Foundation

enum AllocatedBandwidthViewState: MxViewState {
    case idle
    case onProgress
    case populate(bandwidth: [DelegatedBandwidth])
    case onError
    case empty
    case navigateToUndelegateBandwidth(delegatedBandwidth: DelegatedBandwidth)
}
