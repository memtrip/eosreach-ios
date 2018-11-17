import Foundation

enum ResourcesViewState: MxViewState {
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
