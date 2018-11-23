import Foundation

enum SellRamIntent: MxIntent {
    case idle
    case convertKiloBytesToEOSCost(kb: String, costPerKb: Balance)
    case commit(kb: String)
}
