import Foundation

enum ConfirmRamResult: MxResult {
    case idle
    case populate(commitType: RamBundle.CommitType)
    case onProgress
    case onSuccess(actionReceipt: ActionReceipt)
    case genericError
    case errorWithLog(log: String)
}
