import Foundation

enum ViewPrivateKeysResult: MxResult {
    case idle
    case showPrivateKeys(viewKeyPair: [ViewKeyPair])
    case onProgress
    case noPrivateKeys
}
