import Foundation
import RxSwift

protocol EosCreateAccountRequest {

    func createAccount(
        transactionIdentifier: String,
        accountName: String,
        publicKey: String
    ) -> Single<Result<CreateAccountReceipt, EosCreateAccountError>>
}

enum EosCreateAccountError : ApiError {
    case genericError
    case fatalError
    case accountNameExists
}
