import Foundation

enum ResourcesViewState: MxViewState {
    case idle
    case populate(eosAccount: EosAccount)
    case navigateToManageBandwidth
    case navigateToManageBandwidthWithAccountName
    case navigateToManageRam
}
