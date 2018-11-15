import Foundation
import RxSwift

protocol BlockProducerRequest {

    func getBlockProducers(limit: Int) -> Single<Result<[BlockProducerDetails], BlockProducerError>>

    func getSingleBlockProducer(accountName: String) -> Single<Result<BlockProducerDetails, BlockProducerError>>
}

enum BlockProducerError : ApiError {
    case genericError
    case onChainProducerJsonMissing
}
