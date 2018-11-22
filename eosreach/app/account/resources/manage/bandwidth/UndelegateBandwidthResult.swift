import Foundation

enum UndelegateBandwidthResult: MxResult {
    case idle
    case populate(manageBandwidthBundle: ManageBandwidthBundle)
    case prepopulate(manageBandwidthBundle: ManageBandwidthBundle, prepopulated: DelegatedBandwidth)
    case navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle)
}
