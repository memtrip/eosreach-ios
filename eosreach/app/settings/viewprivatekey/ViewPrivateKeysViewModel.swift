import Foundation
import RxSwift
import eosswift

class ViewPrivateKeysViewModel: MxViewModel<ViewPrivateKeysIntent, ViewPrivateKeysResult, ViewPrivateKeysViewState> {
    
    private let getAccountsNamesForPublicKey = GetAccountsNamesForPublicKey()
    private let eosKeyManager = EosKeyManagerImpl()
    
    override func dispatcher(intent: ViewPrivateKeysIntent) -> Observable<ViewPrivateKeysResult> {
        switch intent {
        case .idle:
            return just(ViewPrivateKeysResult.idle)
        case .decryptPrivateKeys:
            return showPrivateKeys()
        }
    }

    override func reducer(previousState: ViewPrivateKeysViewState, result: ViewPrivateKeysResult) -> ViewPrivateKeysViewState {
        switch result {
        case .idle:
            return ViewPrivateKeysViewState.idle
        case .showPrivateKeys(let viewKeyPair):
            return ViewPrivateKeysViewState.showPrivateKeys(viewKeyPair: viewKeyPair)
        case .onProgress:
            return ViewPrivateKeysViewState.onProgress
        case .noPrivateKeys:
            return ViewPrivateKeysViewState.noPrivateKeys
        }
    }
   
    private func showPrivateKeys() -> Observable<ViewPrivateKeysResult> {
        return eosKeyManager.getPrivateKeys().flatMap { privateKeys in
            if (privateKeys.isEmpty) {
                return  Single.just(ViewPrivateKeysResult.noPrivateKeys)
            } else {
                return self.getAccountsForPrivateKey(privateKeys: privateKeys)
            }
        }.catchErrorJustReturn(ViewPrivateKeysResult.noPrivateKeys)
            .asObservable()
            .startWith(ViewPrivateKeysResult.onProgress)
    }
    
    private func getAccountsForPrivateKey(privateKeys: [EOSPrivateKey]) -> Single<ViewPrivateKeysResult> {
        return Observable.from(privateKeys).concatMap { eosPrivateKey in
            Observable.zip(
                Observable.just(eosPrivateKey),
                self.getAccountsNamesForPublicKey.names(publicKey: eosPrivateKey.publicKey.base58).asObservable()
            ) { (_, names) in
                return ViewKeyPair(
                    eosPrivateKey: eosPrivateKey,
                    associatedAccounts: names
                )
            }.toArray().map { keyPairs in
                ViewPrivateKeysResult.showPrivateKeys(viewKeyPair: keyPairs)
            }.catchErrorJustReturn(ViewPrivateKeysResult.noPrivateKeys)
        }.asSingle()
    }
}
