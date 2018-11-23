import Foundation

enum ConfirmRamResult: MxResult {
    case idle
    case populate
    case onProgress
    case onSuccess(actionReceipt: ActionReceipt)
    case genericError
    case errorWithLog(log: String)
}
