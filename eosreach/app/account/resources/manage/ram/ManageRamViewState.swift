import Foundation

enum ManageRamViewState: MxViewState {
    case idle
    case onProgress
    case onRamPriceError
    case populate(ramPricePerKb: Balance)
}
