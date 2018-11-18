import Foundation

struct BalanceViewState: MxViewState, Copy {
    var view: View
    var accountBalances: AccountBalanceList = AccountBalanceList(balances: [])
    
    enum View {
        case idle
        case populate
        case onAirdropError
        case onAirdropProgress
        case onAirdropSuccess
        case navigateToActions(contractAccountBalance: ContractAccountBalance)
    }
}
