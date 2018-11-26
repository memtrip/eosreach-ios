import Foundation
import StoreKit

enum CreateAccountIntent: MxIntent {
    case idle
    case startBillingConnection
    case onSKProductSuccess(skProduct: SKProduct)
    case purchaseAccount(accountName: String)
    case accountPurchased(transactionId: String, accountName: String)
    case goToSettings
    case limboRetry
}
