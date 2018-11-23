import Foundation

enum ManageRamIntent: MxIntent {
    case idle
    case start(symbol: String)
}
