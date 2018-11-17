import Foundation

struct BalanceViewState: MxViewState {
    let view: View
    let accountBalances: AccountBalanceList = AccountBalanceList(balances: [])
    
    enum View {
        case idle
        case populate
        case onAirdropError
        case onAirdropProgress
        case onAirdropSuccess
        case navigateToCreateAccount
        case navigateToActions(contractAccountBalance: ContractAccountBalance)
    }
}
