import Foundation

enum DelegateBandwidthResult: MxResult {
    case idle
    case populate(manageBandwidthBundle: ManageBandwidthBundle)
    case navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle)
}
