import Foundation

struct EosAccountResource {
    let used: Int64
    let available: Int64
    let staked: Balance?
    let delegated: Balance?
}
