import Foundation

enum SellRamResult: MxResult {
    case idle
    case navigateToConfirmRamForm(kilobytes: String)
    case updateCostPerKiloByte(eosCost: String)
    case emptyRamError
}
