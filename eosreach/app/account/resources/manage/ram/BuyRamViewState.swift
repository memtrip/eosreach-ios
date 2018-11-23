import Foundation

enum BuyRamViewState: MxViewState {
    case idle
    case navigateToConfirmRamForm(kilobytes: String)
    case updateCostPerKiloByte(eosCost: String)
    case emptyRamError
}
