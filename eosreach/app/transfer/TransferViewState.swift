import Foundation

enum TransferViewState: MxViewState {
    case idle
    case populate(availableBalance: String)
    case moveToBalanceField
    case navigateToConfirm(transferFormBundle: TransferFormBundle)
    case validationError(message: String)
}
