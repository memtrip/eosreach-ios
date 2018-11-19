import Foundation

enum ResourcesResult: MxResult {
    case idle
    case populate(eosAccount: EosAccount)
    case navigateToManageBandwidth
    case navigateToManageBandwidthWithAccountName
    case navigateToManageRam
}
