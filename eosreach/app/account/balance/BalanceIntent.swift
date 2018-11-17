import Foundation

enum BalanceIntent: MxIntent {
    case idle
    case start(accountBalances: AccountBalanceList)
    case scanForAirdropTokens(accountName: String)
    case navigateToCreateAccount
    case navigateToActions(balance: ContractAccountBalance)
}
