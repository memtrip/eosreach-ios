import Foundation

enum RegisteredBlockProducersIntent: MxIntent {
    case idle
    case start
    case retry
    case loadMore(lastAccountName: String)
    case websiteSelected(website: String)
    case registeredBlockProducersSelected(accountName: String)
}
