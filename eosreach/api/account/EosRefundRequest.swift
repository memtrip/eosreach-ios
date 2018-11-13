import Foundation

struct EosRefundRequest {
    let owner: String
    let requestTime: Date
    let net: Balance
    let cpu: Balance
}
