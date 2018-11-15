import Foundation
import RxSwift
import eosswift

class AccountsForPublicKeyRequestImpl : AccountsForPublicKeyRequest {

    let historyApi: HistoryApi = HistoryApiModule.create()
    let chainApi: ChainApi = ChainApiModule.create()

    func getAccountsForKey(publicKey: String) -> Single<Result<AccountsForPublicKey, AccountForKeyError>> {
        return historyApi.getKeyAccounts(body: GetKeyAccounts(public_key: publicKey)).flatMap { response in
            if (response.success) {
                return self.getBalance(publicKey: publicKey, accountNameList: response.body!.account_names)
            } else {
                return Single.just(Result<AccountsForPublicKey, AccountForKeyError>(error: AccountForKeyError.FailedRetrievingAccountList))
            }
        }
    }

    private func getBalance(publicKey: String, accountNameList: [String]) -> Single<Result<AccountsForPublicKey, AccountForKeyError>> {

        return Observable.from(accountNameList)
            .concatMap { accountName in
                Observable.zip(
                    Observable.just(accountName),
                    self.chainApi.getCurrencyBalance(body: GetCurrencyBalance(
                        code: "eosio.token",
                        account: accountName,
                        symbol: nil
                    )).asObservable()) { (_, response) in
                        if (response.success) {
                            let balance = response.body!
                            if (balance.count > 0) {
                                return AccountNameSystemBalance(accountName: accountName, systemBalance: balance[0])
                            } else {
                                return AccountNameSystemBalance(accountName: accountName, systemBalance: nil)
                            }
                        } else {
                            throw InnerAccountFailed.genericError
                        }
                    }
            }.toArray().map { accountSystemBalanceList in
                return Result<AccountsForPublicKey, AccountForKeyError>(data: AccountsForPublicKey(
                    publicKey: publicKey,
                    accounts: accountSystemBalanceList))
            }.asSingle()
    }

    enum InnerAccountFailed: Error {
        case genericError
    }
}
