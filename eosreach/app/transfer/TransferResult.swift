import Foundation

enum TransferResult: MxResult {
    case idle
    case populate(availableBalance: String)
    case moveToBalanceField
    case navigateToConfirm(transferFormBundle: TransferFormBundle)
    case validationError(message: String)
}
