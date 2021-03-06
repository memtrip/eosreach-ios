import Foundation
import RxSwift
import eosswift

class BandwidthRequestImpl : BandwidthRequest {

    let delegateBandwidthChain: DelegateBandwidthChain
    let undelegateBandwidthChain: UnDelegateBandwidthChain

    init() {
        let chainApi = ChainApiModule.create()
        delegateBandwidthChain = DelegateBandwidthChain(chainApi: chainApi)
        undelegateBandwidthChain = UnDelegateBandwidthChain(chainApi: chainApi)
    }

    func delegate(
        fromAccount: String,
        toAccount: String,
        netAmount: String,
        cpuAmount: String,
        transfer: Bool,
        authorizingPrivateKey: EOSPrivateKey,
        transactionExpiry: Date
    ) -> Single<Result<ActionReceipt, BandwidthError>> {
        return delegateBandwidthChain.delegateBandwidth(
            args: DelegateBandwidthChain.Args(
                from: fromAccount,
                receiver: toAccount,
                netQuantity: netAmount,
                cpuQuantity: cpuAmount,
                transfer: transfer),
            transactionContext: TransactionContext(
                authorizingAccountName: fromAccount,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry()
        )).map { response in
            if (response.success) {
                return Result(data: ActionReceipt(
                    transactionId: response.body!.transaction_id,
                    authorizingAccountName: fromAccount
                ))
            } else {
                return Result(error: BandwidthError.transactionError(body: response.errorBody!))
            }
        }.catchErrorJustReturn(Result(error: BandwidthError.genericError))
    }
    
    func undelegate(
        fromAccount: String,
        toAccount: String,
        netAmount: String,
        cpuAmount: String,
        authorizingPrivateKey: EOSPrivateKey,
        transactionExpiry: Date
    ) -> Single<Result<ActionReceipt, BandwidthError>> {
        return undelegateBandwidthChain.undelegateBandwidth(
            args: UnDelegateBandwidthChain.Args(
                from: fromAccount,
                receiver: toAccount,
                netQuantity: netAmount,
                cpuQuantity: cpuAmount),
            transactionContext: TransactionContext(
                authorizingAccountName: fromAccount,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: transactionExpiry)
        ).map { response in
            if (response.success) {
                return Result(data: ActionReceipt(
                    transactionId: response.body!.transaction_id,
                    authorizingAccountName: fromAccount))
            } else {
                return Result(error: BandwidthError.transactionError(body: response.errorBody!))
            }
        }.catchErrorJustReturn(Result(error: BandwidthError.genericError))
    }
}
