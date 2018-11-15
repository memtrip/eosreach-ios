import Foundation
import RxSwift

class GetBandwidthRequestImpl : GetBandwidthRequest {

    func getBandwidth(accountName: String) -> Single<Result<[DelegatedBandwidth], GetBandwidthError>> {
        fatalError("not implemented")
    }
}
