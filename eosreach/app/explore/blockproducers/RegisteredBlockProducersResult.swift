import Foundation

enum RegisteredBlockProducersResult: MxResult {
    case idle
    case onProgress
    case empty
    case onLoadMoreProgress
    case onError
    case onLoadMoreError
    case onSuccess(registeredBlockProducers: [RegisteredBlockProducer])
    case websiteSelected(url: String)
    case registeredBlockProducersSelected(accountName: String)
}
