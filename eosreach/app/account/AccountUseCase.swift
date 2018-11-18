import Foundation
import RxSwift
import eosswift

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
                return self.getBalances(eosAccount: eosAccount, primaryEosPrice: eosPrice, primaryBalance: self.createBalanceEntity(
                    accountName: accountName,
                    contractName: contractName,
                    symbol: eosAccount.balance.symbol
                ))
            } else {
                return Single.just(AccountView(error: AccountViewError.fetchingAccount))
            }
        }.catchErrorJustReturn(AccountView(error: AccountViewError.fetchingAccount))
    }
    
    private func createBalanceEntity(
        accountName: String,
        contractName: String,
        symbol: String
    ) -> BalanceEntity {
        let balanceEntity = BalanceEntity()
        balanceEntity.accountName = accountName
        balanceEntity.contractName = contractName
        balanceEntity.symbol = symbol
        return balanceEntity
    }
    
    private func getBalances(eosAccount: EosAccount, primaryEosPrice: EosPrice, primaryBalance: BalanceEntity) -> Single<AccountView> {
        return getBalances.select(accountName: eosAccount.accountName).flatMap { balanceEntities in
            var balances = Array<BalanceEntity>()
            balances.append(primaryBalance)
            balances.append(contentsOf: balanceEntities)
            return Observable.from(balances).concatMap { balanceEntity in
                Observable.zip(
                    Observable.just(balanceEntity),
                    self.chainApi.getCurrencyBalance(body: GetCurrencyBalance(
                        code: balanceEntity.contractName,
                        account: balanceEntity.accountName,
                        symbol: nil
                    )).asObservable()) { (_, response) -> ContractAccountBalance in
                        if (response.success) {
                            let balanceList = response.body!
                            if (balanceList.isNotEmpty()) {
                                let balance = BalanceFormatter.deserialize(balance: balanceList[0])
                                return ContractAccountBalance(
                                    contractName: balanceEntity.contractName,
                                    accountName: balanceEntity.accountName,
                                    balance: balance,
                                    exchangeRate: self.parsePrice(
                                        eosAccount: eosAccount,
                                        eosPrice: primaryEosPrice,
                                        balance: balance)
                                )
                            } else {
                                return ContractAccountBalance.unavailable()
                            }
                        } else {
                            throw GetBalancesError.innerBalanceFailed
                        }
                    }
            }.toArray().map { contractAccountBalances in
                let accountBalanceList = AccountBalanceList(
                    balances: contractAccountBalances.filter { balance in
                        !balance.unavailable
                    }
                )
                return AccountView(
                    eosPrice: self.inferEosPrice(balances: accountBalanceList.balances),
                    eosAccount: eosAccount,
                    balances: accountBalanceList
                )
            }.asSingle()
        }
    }
    
    private func parsePrice(eosAccount: EosAccount, eosPrice: EosPrice, balance: Balance) -> EosPrice {
        if (eosAccount.balance.symbol == balance.symbol) {
            return eosPrice
        } else {
            return EosPrice.unavailable()
        }
    }
    
    private func inferEosPrice(balances: [ContractAccountBalance]) -> EosPrice {
        if (balances.isNotEmpty()) {
            return balances[0].exchangeRate
        } else {
            return EosPrice.unavailable()
        }
    }
    
    enum GetBalancesError : Error {
        case innerBalanceFailed
    }
}
