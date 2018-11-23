import Foundation

enum TransferIntent: MxIntent {
    case idle
    case start(contractAccountBalance: ContractAccountBalance)
    case moveToBalanceField
    case submitForm(
        toAccountName: String,
        amount: String,
        memo: String,
        contractAccountBalance: ContractAccountBalance)
}
