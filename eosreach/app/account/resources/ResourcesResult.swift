import Foundation

enum ResourcesResult: MxResult {
    case idle
    case populate(eosAccount: EosAccount, contractAccountBalance: ContractAccountBalance)
    case navigateToManageBandwidth
    case navigateToManageBandwidthWithAccountName
    case navigateToManageRam
    case refundProgress
    case refundSuccess
    case refundFailed
    case refundFailedWithLog(log: String)
}
