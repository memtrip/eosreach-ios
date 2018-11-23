import Foundation

enum ConfirmRamViewState: MxViewState {
    case idle
    case populate
    case onProgress
    case onSuccess(actionReceipt: ActionReceipt)
    case genericError
    case errorWithLog(log: String)
}
