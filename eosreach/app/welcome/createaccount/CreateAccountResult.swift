import Foundation
import StoreKit

enum CreateAccountResult: MxResult {
    case idle
    case startBillingConnection
    case onSKProductSuccess(formattedPrice: String, skProduct: SKProduct)
    case onAccountNameValidationFailed
    case onAccountNameValidationNumberStartFailed
    case onAccountNameValidationPassed
    case onCreateAccountProgress
    case onCreateAccountSuccess(accountName: String, privateKey: String)
    case onCreateAccountFatalError
    case onCreateAccountUsernameExists
    case onImportKeyProgress
    case onImportKeyError
    case navigateToAccounts(accountName: String)
}
