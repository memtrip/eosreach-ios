import Foundation

enum ManageRamResult: MxResult {
    case idle
    case onProgress
    case onRamPriceError
    case populate(ramPricePerKb: Balance)
}
