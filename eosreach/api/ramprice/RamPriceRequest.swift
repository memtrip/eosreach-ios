import Foundation
import RxSwift

protocol RamPriceRequest {
    func getRamPrice(symbol: String) -> Single<Result<Balance, RamPriceError>>
}

enum RamPriceError : ApiError {
    case genericError
}
