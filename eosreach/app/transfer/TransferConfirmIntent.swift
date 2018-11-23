import Foundation

enum TransferConfirmIntent: MxIntent {
    case idle
    case start(transferFormBundle: TransferFormBundle)
    case transfer(transferFormBundle: TransferFormBundle)
}
