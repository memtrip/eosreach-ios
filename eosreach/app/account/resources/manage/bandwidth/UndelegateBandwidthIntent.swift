import Foundation

enum UndelegateBandwidthIntent: MxIntent {
    case idle
    case start(manageBandwidthBundle: ManageBandwidthBundle, prepopulated: DelegatedBandwidth?)
    case confirm(
        toAccount: String,
        netAmount: String,
        cpuAmount: String,
        contractAccountBalance: ContractAccountBalance)
}
