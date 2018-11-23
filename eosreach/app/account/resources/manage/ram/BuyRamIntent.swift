import Foundation

enum BuyRamIntent: MxIntent {
    case idle
    case convertKiloBytesToEOSCost(kb: String, costPerKb: Balance)
    case commit(kb: String)
}
