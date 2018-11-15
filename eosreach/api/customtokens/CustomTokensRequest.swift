import Foundation
import RxSwift

protocol CustomTokensRequest {
    func getCustomTokens() -> Single<Result<TokenParent, CustomTokensError>>
}

enum CustomTokensError : ApiError {
    case genericError
    case noAirDrops
}
