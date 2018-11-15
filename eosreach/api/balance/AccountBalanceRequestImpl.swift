import Foundation
import eosswift
import RxSwift

class AccountBalanceRequestImpl : AccountBalanceRequest {

    let chainApi: ChainApi = ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url())
    
    func getBalance(contractName: String, accountName: String, symbol: String, eosPrice: EosPrice) -> Single<Result<AccountBalanceList, BalanceError>> {
        return chainApi.getCurrencyBalance(body: GetCurrencyBalance(
            code: contractName,
            account: accountName,
            symbol: symbol)).map { response in
                if (response.success) {
                    let accountBalanceList = AccountBalanceList(balances: self.getContractAccountBalances(
                            contractName: contractName,
                            accountName: accountName,
                            contractBalances: response.body!,
                            eosPrice: eosPrice
                        )
                    )
                    return Result(data: accountBalanceList)
                } else {
                    return Result(error: BalanceError.failedRetrievingBalance(code: response.statusCode, body: ""))
                }
        }
    }

    private func getContractAccountBalances(
        contractName: String,
        accountName: String,
        contractBalances: [String],
        eosPrice: EosPrice
    ) -> [ContractAccountBalance] {
        return contractBalances.map { balance in
            return ContractAccountBalance(
                contractName: contractName,
                accountName: accountName,
                balance: BalanceFormatter.deserialize(balance: balance),
                exchangeRate: eosPrice,
                unavailable: false)
        }
    }
}
