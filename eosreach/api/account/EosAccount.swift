import Foundation

struct EosAccount {
    let accountName: String
    let balance: Balance
    let netResource: EosAccountResource
    let cpuResource: EosAccountResource
    let ramResource: EosAccountResource
    let eosAcconuntVote: EosAccountVote?
    let eosRefundRequest: EosRefundRequest?

    func hasVoted() -> Bool {
        return eosAcconuntVote != nil
    }
}
