import Foundation

struct AccountViewState: MxViewState, Copy {
    var view: View
    var accountName: String? = nil
    var accountView: AccountView? = nil
    var page: AccountPage = AccountPage.balances
    
    init(view: View) {
        self.view = view
    }
    
    enum View {
        case idle
        case onProgress
        case onSuccess
        case onErrorFetchingAccount
        case onErrorFetchingBalances
        case openNavigation
        case navigateToExplore
    }
}
