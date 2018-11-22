import Foundation

struct BandwidthFormBundle: BundleModel {
    let targetAccount: String
    let netAmount: Balance
    let cpuAmount: Balance
    let transfer: Bool
    let contractAccountBalance: ContractAccountBalance
    let type: CommitType
    
    enum CommitType {
        case delegate
        case undelegate
    }
}
