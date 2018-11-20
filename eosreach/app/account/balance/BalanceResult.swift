import Foundation

enum BalanceResult: MxResult {
    case idle
    case emptyBalances
    case populate(accountBalances: AccountBalanceList)
    case onAirdropError
    case onAirdropEmpty
    case onAirdropCustomTokenTableEmpty
    case onAirdropSuccess
    case onAirdropProgress
    case navigateToActions(contractAccountBalance: ContractAccountBalance)
}
