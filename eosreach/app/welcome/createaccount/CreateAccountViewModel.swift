import Foundation
import RxSwift
import StoreKit

class CreateAccountViewModel: MxViewModel<CreateAccountIntent, CreateAccountResult, CreateAccountViewState> {

    override func dispatcher(intent: CreateAccountIntent) -> Observable<CreateAccountResult> {
        switch intent {
        case .idle:
            return just(CreateAccountResult.idle)
        case .startBillingConnection:
            return just(CreateAccountResult.startBillingConnection)
        case .onSKProductSuccess(let skProduct):
            return just(formatPrice(skProduct: skProduct))
        case .onSKProductError:
            return just(CreateAccountResult.onSKProductError)
        }
    }

    override func reducer(previousState: CreateAccountViewState, result: CreateAccountResult) -> CreateAccountViewState {
        switch result {
        case .idle:
            return CreateAccountViewState.idle
        case .startBillingConnection:
            return CreateAccountViewState.startBillingConnection
        case .onSKProductSuccess(let formattedPrice, let skProduct):
            return CreateAccountViewState.onSKProductSuccess(formattedPrice: formattedPrice, skProduct: skProduct)
        case .onSKProductError:
            return CreateAccountViewState.onSKProductError()
        case .onAccountNameValidationPassed:
            return CreateAccountViewState.onAccountNameValidationPassed
        case .onCreateAccountProgress:
            return CreateAccountViewState.onCreateAccountProgress
        case .onCreateAccountSuccess(let transactionIdentifier):
            return CreateAccountViewState.onCreateAccountSuccess(transactionIdentifier: transactionIdentifier)
        case .onImportKeyProgress:
            return CreateAccountViewState.onImportKeyProgress
        case .onImportKeyError:
            return CreateAccountViewState.onImportKeyError
        case .navigateToAccounts:
            return CreateAccountViewState.navigateToAccounts
        }
    }
    
    private func formatPrice(skProduct: SKProduct) -> CreateAccountResult {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = skProduct.priceLocale
        let formattedPrice = numberFormatter.string(from: skProduct.price)!
        return CreateAccountResult.onSKProductSuccess(formattedPrice: formattedPrice, skProduct: skProduct)
    }
}
