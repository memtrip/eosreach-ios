import Foundation

enum ViewBlockProducerViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case empty
    case onInvalidUrl(url: String)
    case navigateToUrl(url: String)
    case populate(blockProducerDetails: BlockProducerDetails)
    case sendEmail(email: String)
    case navigateToOwnerAccount(owner: String)
}
