import Foundation
import RxSwift
import eosswift

class EosCreateAccountRequestImpl : EosCreateAccountRequest {

    private let receiptDataRequest = ReceiptDataRequest()
    private let eosCreateAccountApi = EosCreateAccountApi()
    
    func createAccount(
        transactionIdentifier: String,
        accountName: String,
        publicKey: String
    ) -> Single<Result<CreateAccountReceipt, EosCreateAccountError>> {
        return receiptDataRequest.retrieveReceipt().flatMap { receipt in
            return self.eosCreateAccountApi.createAccount(
                purchaseToken: receipt,
                accountName: accountName,
                publicKey: publicKey
            ).map { response in
                if (response.success && response.body != nil) {
                    return Result(data: CreateAccountReceipt(transactionId: response.body!.transactionId))
                } else {
                    return Result(error: EosCreateAccountError.genericError)
                }
            }.catchError { error in
                let httpErrorResponse = error as! HttpErrorResponse<CreateAccountError>
                if (httpErrorResponse.body != nil) {
                    switch httpErrorResponse.body!.errorCode {
                    case "PUBLIC_KEY_INVALID_FORMAT":
                        return Single.just(Result(error: EosCreateAccountError.fatalError))
                    case "ACCOUNT_NAME_EXISTS":
                        return Single.just(Result(error: EosCreateAccountError.accountNameExists))
                    default:
                        return Single.just(Result(error: EosCreateAccountError.genericError))
                    }
                } else {
                    return Single.just(Result(error: EosCreateAccountError.genericError))
                }
            }
        }.catchErrorJustReturn(Result(error: EosCreateAccountError.fatalError))
    }
}
