import Foundation
import RxSwift

protocol EosPriceRequest {
    func getPrice(currencyCode: String) -> Single<Result<EosPrice, EosPriceError>>
}

enum EosPriceError : ApiError {
    case generic
    case unsupportedCurrency
}
