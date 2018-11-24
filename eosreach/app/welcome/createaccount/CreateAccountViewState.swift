import Foundation
import StoreKit

enum CreateAccountViewState: MxViewState {
    case idle
    case startBillingConnection
    case onSKProductSuccess(formattedPrice: String, skProduct: SKProduct)
    case onSKProductError()
    case onAccountNameValidationPassed
    case onCreateAccountProgress
    case onCreateAccountSuccess(transactionIdentifier: String)
    case onImportKeyProgress
    case onImportKeyError
    case navigateToAccounts
}
