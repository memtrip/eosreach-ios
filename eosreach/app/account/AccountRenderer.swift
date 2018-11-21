import Foundation

class AccountRenderer {
    
    let layout: AccountViewLayout
    
    init(accountViewLayout: AccountViewLayout) {
        self.layout = accountViewLayout
    }
    
    func render(state: AccountViewState) {
        if let accountName = state.accountName {
            layout.populateTitle(title: accountName)
        }
        layoutState(state: state)
    }
    
    private func layoutState(state: AccountViewState) {
        switch state.view {
        case .idle:
            break
        case .onProgress:
            layout.showProgress()
        case .onSuccess:
            let balances = state.accountView!.balances!.balances
            let eosPrice = state.accountView!.eosPrice!
            
            self.layout.populate(accountView: state.accountView!, page: state.page)
            
            if (balances.isNotEmpty()) {
                let eosBalance = balances[0].balance.amount
                if (eosPrice.unavailable) {
                    self.layout.showPriceUnavailable()
                } else {
                    let formattedPrice = CurrencyPairFormatter.formatAmountCurrencyPairValue(amount: eosBalance, eosPrice: eosPrice)
                    self.layout.showPrice(formattedPrice: formattedPrice)
                }
            } else {
                self.layout.showPriceUnavailable()
            }
        case .onErrorFetchingAccount:
            layout.showGetAccountError()
        case .onErrorFetchingBalances:
            layout.showGetBalancesError()
        case .openNavigation:
            layout.openNavigation()
        case .navigateToExplore:
            layout.navigateToExplore()
        case .navigateToImportKey:
            layout.navigateToImportKey()
        case .navigateToCreateAccount:
            layout.navigateToCreateAccount()
        case .navigateToSettings:
            layout.navigateToSettings()
        }
    }
}
