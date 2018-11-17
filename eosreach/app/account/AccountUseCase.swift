import Foundation
import RxSwift

class AccountUseCase {
    
    private let eosAccountRequest = EosAccountRequestImpl()
    private let getBalances = GetBalances()
    private let chainApi = ChainApiModule.create()
    private let eosPriceUseCase = EosPriceUseCase()
    
    func getAccountDetails(contractName: String, accountName: String) -> Single<AccountView> {
        return eosPriceUseCase.getPrice()
            .catchErrorJustReturn(EosPrice.unavailable())
            .flatMap { price in
                return self.getAccount(contractName: contractName, accountName: accountName, eosPrice: price)
            }
    }
    
    private func getAccount(
        contractName: String,
        accountName: String,
        eosPrice: EosPrice
    ) -> Single<AccountView> {
        return eosAccountRequest.getAccount(accountName: accountName).flatMap { response in
            if (response.success()) {
                let eosAccount = response.data!
                return self.getBalances(eosAccount: eosAccount, primaryEosPrice: eosPrice, primaryBalance: BalanceModel(
                    accountName: accountName,
                    contractName: contractName,
                    symbol: eosAccount.balance.symbol
                ))
            } else {
                return Single.just(AccountView(error: AccountViewError.fetchingAccount))
            }
        }.catchErrorJustReturn(AccountView(error: AccountViewError.fetchingAccount))
    }
    
    private func getBalances(eosAccount: EosAccount, primaryEosPrice: EosPrice, primaryBalance: BalanceModel) -> Single<AccountView> {
        fatalError()
    }
}

struct BalanceModel {
    let accountName: String
    let contractName: String
    let symbol: String
}
