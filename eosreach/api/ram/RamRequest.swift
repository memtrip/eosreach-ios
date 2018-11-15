import Foundation
import RxSwift
import eosswift

protocol RamRequest {

    func buy(
        receiver: String,
        kb: Double,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<ActionReceipt, RamError>>

    func sell(
        account: String,
        kb: Double,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<ActionReceipt, RamError>>
}

enum RamError : ApiError {
    case genericError
    case withLog(body: String)
}
