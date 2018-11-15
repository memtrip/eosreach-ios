import Foundation
import RxSwift

class EosCreateAccountRequestImpl : EosCreateAccountRequest {

    func createAccount(purchaseToken: String, accountName: String, publicKey: String) -> Single<Result<CreateAccountReceipt, EosCreateAccountError>> {
        fatalError("not implemented")
    }
}
