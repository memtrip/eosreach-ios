import Foundation
import RxSwift

class TransferViewModel: MxViewModel<TransferIntent, TransferResult, TransferViewState> {
    
    override func dispatcher(intent: TransferIntent) -> Observable<TransferResult> {
        switch intent {
        case .idle:
            return just(TransferResult.idle)
        case .start(let contractAccountBalance):
            return just(TransferResult.populate(
                availableBalance: BalanceFormatter.formatEosBalance(balance: contractAccountBalance.balance)))
        case .moveToBalanceField:
            return just(TransferResult.moveToBalanceField)
        case .submitForm(let toAccountName, let amount, let memo, let contractAccountBalance):
            return just(validateForm(transferFormBundle: TransferFormBundle(
                contractAccountBalance: contractAccountBalance,
                toAccountName: toAccountName,
                amount: amount,
                memo: memo)))
        }
    }

    override func reducer(previousState: TransferViewState, result: TransferResult) -> TransferViewState {
        switch result {
        case .idle:
            return TransferViewState.idle
        case .populate(let availableBalance):
            return TransferViewState.populate(availableBalance: availableBalance)
        case .moveToBalanceField:
            return TransferViewState.moveToBalanceField
        case .navigateToConfirm(let transferFormBundle):
            return TransferViewState.navigateToConfirm(transferFormBundle: transferFormBundle)
        case .validationError(let message):
            return TransferViewState.validationError(message: message)
        }
    }
    
    private func validateForm(transferFormBundle: TransferFormBundle) -> TransferResult {
        if (transferFormBundle.amount.isEmpty) {
            return TransferResult.validationError(message: R.string.transferStrings.transfer_form_account_validation())
        } else if (transferFormBundle.amount.isEmpty) {
            return TransferResult.validationError(message: R.string.transferStrings.transfer_form_amount_validation())
        } else {
            return TransferResult.navigateToConfirm(transferFormBundle: transferFormBundle)
        }
    }
}
