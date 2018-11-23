import Foundation

enum BuyRamResult: MxResult {
    case idle
    case navigateToConfirmRamForm(kilobytes: String)
    case updateCostPerKiloByte(eosCost: String)
    case emptyRamError
}
