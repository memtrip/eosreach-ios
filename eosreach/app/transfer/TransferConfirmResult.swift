import Foundation

enum TransferConfirmResult: MxResult {
    case idle
    case populate(transferFormBundle: TransferFormBundle)
    case onProgress
    case onSuccess(actionReceipt: ActionReceipt)
    case onError
    case errorWithLog(log: String)
}
