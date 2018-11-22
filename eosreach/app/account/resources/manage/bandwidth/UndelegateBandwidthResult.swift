import Foundation

enum UndelegateBandwidthResult: MxResult {
    case idle
    case populate(manageBandwidthBundle: ManageBandwidthBundle)
    case navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle)
}
