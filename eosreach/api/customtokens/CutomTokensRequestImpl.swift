import Foundation
import RxSwift
import eosswift

class CustomTokensRequestImpl : CustomTokensRequest {

    private let chainApi = ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url())

    func getCustomTokens() -> Single<Result<TokenParent, CustomTokensError>> {
        return chainApi.getTableRows(body: GetTableRows(
            scope: "customtokens",
            code: "customtokens",
            table: "tokens",
            table_key: "",
            json: true,
            limit: 100,
            lower_bound: "",
            upper_bound: "",
            key_type: "",
            index_position: "",
            encode_type: ""
        )).map { response in
            if (response.success) {
                return Result(data: TokenParent(tokens: response.body!.rows.map { token in
                    return Token(
                        uuid: token["uuid"]!.jsonValue as! Double,
                        owner: token["owner"]!.jsonValue as! String,
                        customtoken: token["customtoken"]!.jsonValue as! String,
                        customasset: token["customasset"]!.jsonValue as! String
                    )
                }))
            } else {
                return Result(error: CustomTokensError.noAirDrops)
            }
        }.catchErrorJustReturn(Result(error: CustomTokensError.genericError))
    }
}
