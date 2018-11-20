import Foundation

struct BalanceViewState: MxViewState, Copy {
    var view: View
    var accountBalances: AccountBalanceList = AccountBalanceList(balances: [])
    
    enum View {
        case idle
        case emptyBalances
        case populate
        case onAirdropError
        case onAirdropEmpty
        case onAirdropCustomTokenTableEmpty
        case onAirdropProgress
        case onAirdropSuccess
        case navigateToActions(contractAccountBalance: ContractAccountBalance)
    }
}
