import Foundation

enum SellRamViewState: MxViewState {
    case idle
    case navigateToConfirmRamForm(kilobytes: String)
    case updateCostPerKiloByte(eosCost: String)
    case emptyRamError
}
