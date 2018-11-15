import Foundation
import RxSwift

protocol GetBandwidthRequest {
    func getBandwidth(accountName: String) -> Single<Result<[DelegatedBandwidth], GetBandwidthError>>
}

enum GetBandwidthError : ApiError {
    case empty
    case genericError
}
