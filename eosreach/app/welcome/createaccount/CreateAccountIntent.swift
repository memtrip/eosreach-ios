import Foundation
import StoreKit

enum CreateAccountIntent: MxIntent {
    case idle
    case startBillingConnection
    case onSKProductSuccess(skProduct: SKProduct)
    case createAccount(accountName: String)
}
