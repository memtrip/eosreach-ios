import Foundation

enum TransferConfirmViewState: MxViewState {
    case idle
    case populate(transferFormBundle: TransferFormBundle)
    case onProgress
    case onSuccess(actionReceipt: ActionReceipt)
    case onError
    case errorWithLog(log: String)
}
