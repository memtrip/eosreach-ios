import Foundation

enum BalanceResult: MxResult {
    case idle
    case populate(accountBalances: AccountBalanceList)
    case onAirdropError
    case onAirdropSuccess
    case onAirdropProgress
    case navigateToActions(contractAccountBalance: ContractAccountBalance)
}
