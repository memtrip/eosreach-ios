import Foundation
import RxSwift
import eosswift

class EosPriceApi {
    
    private let urlSession: URLSession
    
    init(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getPrice(currency: String) -> Single<HttpResponse<Price>> {
        return RxHttp<RequestBody, Price, PriceError>(urlSession, false).single(
            httpRequest: HttpRequest(
                url: R.string.appStrings.app_reach_endpoint_url() + "price/\(currency)",
                method: "GET",
                body: nil
            )
        )
    }
}

struct Price : Decodable {
    let value: Double
    let currency: String
}

struct PriceError : Decodable {
    let error: String
}
