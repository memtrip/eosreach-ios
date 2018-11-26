import Foundation

enum ViewPrivateKeysViewState: MxViewState {
    case idle
    case showPrivateKeys(viewKeyPair: [ViewKeyPair])
    case onProgress
    case noPrivateKeys
}
