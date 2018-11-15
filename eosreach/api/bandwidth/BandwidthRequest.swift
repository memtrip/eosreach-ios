import Foundation
import RxSwift
import eosswift

protocol BandwidthRequest {

    func delegate(
        fromAccount: String,
        toAccount: String,
        netAmount: String,
        cpuAmount: String,
        transfer: Bool,
        authorizingPrivateKey: EOSPrivateKey,
        transactionExpiry: Date
    ) -> Single<Result<ActionReceipt, BandwidthError>>
}

enum BandwidthError : ApiError {
    case transactionError(body: String)
    case genericError
}
