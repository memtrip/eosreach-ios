import Foundation
import RxSwift
import eosswift

class BalanceViewModel: MxViewModel<BalanceIntent, BalanceResult, BalanceViewState> {

    private let customTokensRequest = CustomTokensRequestImpl()
    private let insertBalances = InsertBalances()
    private let chainApi = ChainApiModule.create()
    
    override func dispatcher(intent: BalanceIntent) -> Observable<BalanceResult> {
        switch intent {
        case .idle:
            return just(BalanceResult.idle)
        case .start(let accountBalances):
            return just(showBalances(accountBalanceList: accountBalances))
        case .scanForAirdropTokens(let accountName):
            return scanForAirdropTokens(accountName: accountName)
        case .navigateToActions(let balance):
            return just(BalanceResult.navigateToActions(contractAccountBalance: balance))
        }
    }

    override func reducer(previousState: BalanceViewState, result: BalanceResult) -> BalanceViewState {
        switch result {
        case .idle:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.idle
            }
        case .populate(let accountBalances):
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.populate
                copy.accountBalances = accountBalances
            }
        case .onAirdropError:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.onAirdropError
            }
        case .onAirdropSuccess(let balances):
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.onAirdropSuccess
                copy.accountBalances = AccountBalanceList(balances: balances)
            }
        case .onAirdropProgress:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.onAirdropProgress
            }
        case .navigateToActions(let contractAccountBalance):
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.navigateToActions(contractAccountBalance: contractAccountBalance)
            }
        case .onAirdropEmpty:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.onAirdropEmpty
            }
        case .onAirdropCustomTokenTableEmpty:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.onAirdropCustomTokenTableEmpty
            }
        case .emptyBalances:
            return previousState.copy { copy in
                copy.view = BalanceViewState.View.emptyBalances
            }
        }
    }
    
    private func showBalances(accountBalanceList: AccountBalanceList) -> BalanceResult {
        if (accountBalanceList.balances.isEmpty) {
            return BalanceResult.emptyBalances
        } else {
            return BalanceResult.populate(accountBalances: accountBalanceList)
        }
    }
    
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
                        return Single.just(BalanceResult.onAirdropEmpty)
                    }
                }
            } else {
                switch tokenResponse.error! {
                case .genericError:
                    return Single.just(BalanceResult.onAirdropError)
                case .noAirDrops:
                    return Single.just(BalanceResult.onAirdropCustomTokenTableEmpty)
                }
            }
        }.catchErrorJustReturn(BalanceResult.onAirdropError).asObservable().startWith(BalanceResult.onAirdropProgress)
    }
    
    private func insertAirdrops(accountName: String, balances: [ContractAccountBalance]) -> Single<BalanceResult> {
        return insertBalances.replace(accountName: accountName, contractAccountBalances: balances).map { _ in
            return BalanceResult.onAirdropSuccess(balances: balances)
        }
    }
    
    enum GetBalancesError : Error {
        case innerBalanceFailed
    }
}
