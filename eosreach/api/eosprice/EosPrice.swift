import Foundation

struct EosPrice {
    let value: Double
    let currency: String
    let unavailable: Bool

    static func unavailable() -> EosPrice {
        return EosPrice(
            value: -1,
            currency: "-",
            unavailable: true)
    }
}
