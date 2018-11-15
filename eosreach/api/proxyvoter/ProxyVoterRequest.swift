import Foundation
import RxSwift

protocol ProxyVoterRequest {

    func getProxyVoters(nextAccount: String) -> Single<Result<[ProxyVoterDetails], ProxyVoterError>>

    func getProxy(accountName: String) -> Single<Result<ProxyVoterDetails, ProxyVoterError>>
}

enum ProxyVoterError : ApiError {
    case genericError
}
