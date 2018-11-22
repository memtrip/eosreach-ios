import Foundation

enum DelegateBandwidthViewState: MxViewState {
    case idle
    case populate(manageBandwidthBundle: ManageBandwidthBundle)
    case navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle)
}
