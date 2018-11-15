import Foundation
import RxSwift
import eosswift

class RamRequestImpl : RamRequest {

    private let buyRamBytesChain: BuyRamBytesChain
    private let sellRamChain: SellRamChain

    init() {
        let chainApi = ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url())
        buyRamBytesChain = BuyRamBytesChain(chainApi: chainApi)
        sellRamChain = SellRamChain(chainApi: chainApi)
    }

    func buy(
        receiver: String,
        kb: Double,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<ActionReceipt, RamError>> {
        return buyRamBytesChain.buyRamBytes(
            args: BuyRamBytesChain.Args(
                receiver: receiver,
                quantity: Int64.init(kb*1000)),
            transactionContext: TransactionContext(
                authorizingAccountName: receiver,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry())
        ).map { response in
            if (response.success) {
                return Result(data: ActionReceipt(
                    transactionId: response.body!.transaction_id,
                    authorizingAccountName: receiver
                ))
            } else {
                return Result(error: RamError.withLog(body: response.errorBody!))
            }
        }.catchErrorJustReturn(Result(error: RamError.genericError))
    }

    func sell(
        account: String,
        kb: Double,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<ActionReceipt, RamError>> {
        return sellRamChain.sellRam(
            args: SellRamChain.Args(
                quantity: Int64.init(kb*1000)
            ),
            transactionContext: TransactionContext(
                authorizingAccountName: account,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry())
        ).map { response in
            if (response.success) {
                return Result(data: ActionReceipt(
                    transactionId: response.body!.transaction_id,
                    authorizingAccountName: account
                ))
            } else {
                return Result(error: RamError.withLog(body: response.errorBody!))
            }
        }
    }
}
