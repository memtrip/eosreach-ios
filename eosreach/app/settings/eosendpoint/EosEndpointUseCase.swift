import Foundation
import RxSwift
import eosswift

class EosEndpointUseCase {
    
    func getInfo(endpointUrl: String) -> Single<Result<Info, GetInfoError>> {
        let chainApi = ChainApiFactory.create(rootUrl: endpointUrl)
        return chainApi.getInfo().map { response in
            if (response.success) {
                return Result(data: response.body!)
            } else {
                return Result(error: GetInfoError.generic)
            }
        }.catchErrorJustReturn(Result(error: GetInfoError.generic))
    }
}

enum GetInfoError : ApiError {
    case generic
}
