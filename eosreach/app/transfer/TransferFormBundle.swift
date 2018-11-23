import Foundation

struct TransferFormBundle : BundleModel {
    let contractAccountBalance: ContractAccountBalance
    let toAccountName: String
    let amount: String
    let memo: String
}
