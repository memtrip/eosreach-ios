import Foundation
import eosswift

struct ViewKeyPair {
    let eosPrivateKey: EOSPrivateKey
    let associatedAccounts: [String]
}
