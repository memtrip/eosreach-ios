import Foundation
import RxSwift
import eosswift

class EosCreateAccountApi {

    func createAccount(
        purchaseToken: String,
        accountName: String,
        publicKey: String
    ) -> Single<HttpResponse<CreateAccountResponse>> {
        return RxHttp<CreateAccountRequest, CreateAccountResponse, CreateAccountError>(true).single(
            httpRequest: HttpRequest(
                url: R.string.appStrings.app_reach_endpoint_url() + "createAccount",
                method: "POST",
                body: CreateAccountRequest(
                    purchaseToken: purchaseToken,
                    accountName: accountName,
                    publicKey: publicKey,
                    platform: "IOS")
            )
        )
    }
}

struct CreateAccountRequest : Encodable {
    let purchaseToken: String
    let accountName: String
    let publicKey: String
    let platform: String
}

struct CreateAccountResponse : Decodable {
    let transactionId: String
}

struct CreateAccountError : Decodable {
    let errorCode: String
}
