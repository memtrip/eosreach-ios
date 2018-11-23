import Foundation

struct RamBundle: BundleModel {
    let contractAccountBalance: ContractAccountBalance
    let costPerKb: Balance
    let kb: String
    let commitType: CommitType
    
    enum CommitType {
        case buy
        case sell
    }
}
