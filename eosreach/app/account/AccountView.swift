import Foundation

struct AccountView {
    let eosPrice: EosPrice?
    let eosAccount: EosAccount?
    let balances: AccountBalanceList?
    let error: AccountViewError?
    
    init(error: AccountViewError) {
        self.eosPrice = nil
        self.eosAccount = nil
        self.balances = nil
        self.error = error
    }
    
    init(eosPrice: EosPrice, eosAccount: EosAccount, balances: AccountBalanceList) {
        self.eosPrice = eosPrice
        self.eosAccount = eosAccount
        self.balances = balances
        self.error = nil
    }
    
    func success() -> Bool {
        return error == nil
    }
}

enum AccountViewError {
    case fetchingAccount
    case fetchingBalances
}
