import Foundation
import RxSwift
import eosswift

protocol TransferRequest {

    func transfer(
        contract: String,
        fromAccount: String,
        toAccount: String,
        quantity: String,
        memo: String,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<TransactionCommitted, TransferError>>
}

enum TransferError : ApiError {
    case generic
    case withLog(body: String)
}
