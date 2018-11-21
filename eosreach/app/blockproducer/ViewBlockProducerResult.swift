import Foundation

enum ViewBlockProducerResult: MxResult {
    case idle
    case onProgress
    case onError
    case onChainProducerJsonMissing
    case onInvalidUrl(url: String)
    case navigateToUrl(url: String)
    case populate(blockProducerDetails: BlockProducerDetails)
    case sendEmail(email: String)
    case navigateToOwnerAccount(owner: String)
}
