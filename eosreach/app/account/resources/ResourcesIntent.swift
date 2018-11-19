import Foundation

enum ResourcesIntent: MxIntent {
    case idle
    case start(eosAccount: EosAccount)
    case navigateToManageBandwidth
    case navigateToManageBandwidthWithAccountName(accountName: String)
    case navigateToManageRam
}
