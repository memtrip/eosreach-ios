import Foundation
import RxSwift
import eosswift

class BalanceViewModel: MxViewModel<BalanceIntent, BalanceResult, BalanceViewState> {

    private let customTokensRequest = CustomTokensRequestImpl()
    private let insertBalances = InsertBalances()
    private let chainApi = ChainApiModule.create()
    
    private func scanForAirdropTokens(accountName: String) -> Observable<BalanceResult> {
        return customTokensRequest.getCustomTokens().flatMap { tokenResponse in
            if (tokenResponse.success()) {
                let tokens = tokenResponse.data!.tokens
                return Observable.from(tokens).concatMap { token in
                    Observable.zip(
                        Observable.just(accountName),
                        self.chainApi.getCurrencyBalance(body: GetCurrencyBalance(
                            code: token.customtoken,
                            account: accountName,
                            symbol: nil
                        )).asObservable()
                    ) { (_, response) -> ContractAccountBalance in
                            if (response.success) {
                                let balance = response.body!
                                if (balance.isNotEmpty()) {
                                    return ContractAccountBalance(
                                        contractName: token.customtoken,
                                        accountName: accountName,
                                        balance: BalanceFormatter.deserialize(balance: balance[0]),
                                        exchangeRate: EosPrice.unavailable())
                                } else {
                                    return ContractAccountBalance.unavailable()
                                }
                            } else {
                                throw GetBalancesError.innerBalanceFailed
                            }
                    }
                }.toArray().asSingle().flatMap { contractAccountBalances in
                    let results = contractAccountBalances.filter { balance in
                        return balance.accountName != "unavailable" && balance.contractName != "unavailable"
                    }
                    
                    if (results.isNotEmpty()) {
                        return self.insertAirdrops(accountName: accountName, balances: results)
                    } else {
                        return Single.just(BalanceResult.onAirdropError)
                    }
                }
            } else {
                return Single.just(BalanceResult.onAirdropError)
            }
        }.asObservable().startWith(BalanceResult.onAirdropProgress)
    }
    
    private func insertAirdrops(accountName: String, balances: [ContractAccountBalance]) -> Single<BalanceResult> {
        return insertBalances.replace(accountName: accountName, contractAccountBalances: balances).map { _ in
            return BalanceResult.onAirdropSuccess
        }
    }
    
    override func dispatcher(intent: BalanceIntent) -> Observable<BalanceResult> {
        switch intent {
        case .idle:
            return just(BalanceResult.idle)
        case .start(let accountBalances):
            return just(BalanceResult.populate(accountBalances: accountBalances))
        case .scanForAirdropTokens(let accountName):
            fatalError()
        case .navigateToCreateAccount:
            return just(BalanceResult.navigateToCreateAccount)
        case .navigateToActions(let balance):
            return just(BalanceResult.navigateToActions(contractAccountBalance: balance))
        }
    }

    override func reducer(previousState: BalanceViewState, result: BalanceResult) -> BalanceViewState {
        switch result {
        case .idle:
            fatalError()
        case .populate(let accountBalances):
            fatalError()
        case .onAirdropError:
            fatalError()
        case .onAirdropSuccess:
            fatalError()
        case .onAirdropProgress:
            fatalError()
        case .navigateToCreateAccount:
            fatalError()
        case .navigateToActions(let contractAccountBalance):
            fatalError()
        }
    }
    
    enum GetBalancesError : Error {
        case innerBalanceFailed
    }
}
