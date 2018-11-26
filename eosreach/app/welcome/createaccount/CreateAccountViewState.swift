import Foundation
import StoreKit

enum CreateAccountViewState: MxViewState {
    case idle
    case startBillingConnection
    case onSKProductSuccess(formattedPrice: String, skProduct: SKProduct)
    case onAccountNameValidationFailed
    case onAccountNameValidationNumberStartFailed
    case onAccountNameValidationPassed
    case onCreateAccountProgress
    case onCreateAccountSuccess(privateKey: String)
    case onCreateAccountFatalError
    case onCreateAccountGenericError
    case onCreateAccountUsernameExists
    case onCreateAccountLimbo
    case onImportKeyProgress
    case onImportKeyError
    case navigateToAccounts(accountName: String)
    case goToSettings
}
