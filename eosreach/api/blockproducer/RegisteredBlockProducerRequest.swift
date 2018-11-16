import Foundation
import RxSwift

protocol RegisteredBlockProducerRequest {

    func getProducers(limit: Int, lowerLimit: String) -> Single<Result<[RegisteredBlockProducer], RegisteredBlockProducerError>>
}

enum RegisteredBlockProducerError : ApiError {
    case empty
    case genericError
}
