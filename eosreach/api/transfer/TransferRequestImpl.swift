import Foundation
import RxSwift
import eosswift

class TransferRequestImpl : TransferRequest {

    let transferChain = TransferChain(chainApi: ChainApiModule.create())

    func transfer(
        contract: String,
        fromAccount: String,
        toAccount: String,
        quantity: String,
        memo: String,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<TransactionCommitted, TransferError>> {
        return transferChain.transfer(
            contract: contract,
            args: TransferChain.Args(
                fromAccount: fromAccount,
                toAccount: toAccount,
                quantity: quantity,
                memo: memo),
            transactionContext: TransactionContext(
                authorizingAccountName: fromAccount,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry()
            )
        ).map { response in
            if (response.success) {
                return Result(data: response.body!)
            } else {
                return Result<TransactionCommitted, TransferError>(error: TransferError.withLog(body: response.errorBody!))
            }
        }.catchErrorJustReturn(Result<TransactionCommitted, TransferError>(error: TransferError.generic))
    }
}
