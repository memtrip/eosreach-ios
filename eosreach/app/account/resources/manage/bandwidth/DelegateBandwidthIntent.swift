import Foundation

enum DelegateBandwidthIntent: MxIntent {
    case idle
    case start(manageBandwidthBundle: ManageBandwidthBundle)
    case confirm(
        toAccount: String,
        netAmount: String,
        cpuAmount: String,
        transfer: Bool,
        contractAccountBalance: ContractAccountBalance)
}
