import Foundation

enum ResourcesIntent: MxIntent {
    case idle
    case start(eosAccount: EosAccount, contractAccountBalance: ContractAccountBalance)
    case navigateToManageBandwidth
    case navigateToManageBandwidthWithAccountName(accountName: String)
    case navigateToManageRam
}
