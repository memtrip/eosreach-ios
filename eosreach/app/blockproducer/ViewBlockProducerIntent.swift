import Foundation

enum ViewBlockProducerIntent: MxIntent {
    case idle
    case start(accountName: String?, blockProducerDetails: BlockProducerDetails?)
    case navigateToUrl(url: String)
    case sendEmail(email: String)
    case navigateToOwnerAccount(owner: String)
}
