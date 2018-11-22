import Foundation

enum AllocatedBandwidthIntent: MxIntent {
    case idle
    case start(accountName: String)
    case navigateToUndelegateBandwidth(delegatedBandwidth: DelegatedBandwidth)
}
