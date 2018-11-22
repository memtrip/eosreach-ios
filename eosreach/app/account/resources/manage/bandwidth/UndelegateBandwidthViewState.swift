import Foundation

enum UndelegateBandwidthViewState: MxViewState {
    case idle
    case populate(manageBandwidthBundle: ManageBandwidthBundle)
    case navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle)
}
