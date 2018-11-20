import Foundation
import RxSwift
import eosswift

class ImportKeyViewModel: MxViewModel<ImportKeyIntent, ImportKeyResult, ImportKeyViewState> {

    private let eosKeyManager = EosKeyManagerFactory.create()
    private let accountsForPublicKeyRequest = AccountsForPublicKeyRequestImpl()
    private let insertAccountsForPublicKey = InsertAccountsForPublicKey()

    override func dispatcher(intent: ImportKeyIntent) -> Observable<ImportKeyResult> {
        switch intent {
        case .idle:
            return just(ImportKeyResult.idle)
        case .importKey(let privateKey):
            return importKey(privateKey: privateKey)
        case .viewSource:
            return just(ImportKeyResult.navigateToGithubSource)
        case .navigateToSettings:
            return just(ImportKeyResult.navigateToSettings)
        }
    }

    override func reducer(previousState: ImportKeyViewState, result: ImportKeyResult) -> ImportKeyViewState {
        switch result {
        case .idle:
            return ImportKeyViewState.idle
        case .onProgress:
            return ImportKeyViewState.onProgress
        case .onSuccess:
            return ImportKeyViewState.onSuccess
        case .navigateToGithubSource:
            return ImportKeyViewState.navigateToGithubSource
        case .navigateToSettings:
            return ImportKeyViewState.navigateToSettings
        case .genericError:
            return ImportKeyViewState.genericError
        case .noAccounts:
            return ImportKeyViewState.noAccounts
        case .invalidKey:
            return ImportKeyViewState.invalidKey
        }
    }

    private func importKey(privateKey: String) -> Observable<ImportKeyResult> {
        return eosKeyManager.createEosPrivateKey(value: privateKey).flatMap { eosPrivateKey in
            return self.eosKeyManager.importPrivateKey(eosPrivateKey: eosPrivateKey).flatMap { publicKey in
                return self.accountsForPublicKeyRequest.getAccountsForKey(publicKey: publicKey).flatMap { result in
                    if (result.success()) {
                        let publicKey = result.data!.publicKey
                        let accounts = result.data!.accounts
                        if (accounts.isEmpty) {
                            return Single.just(ImportKeyResult.noAccounts)
                        } else {
                            return self.insertAccountsForPublicKey.insertAccounts(
                                publicKey: publicKey,
                                accounts: accounts
                            ).map { _ in
                                return ImportKeyResult.onSuccess
                            }
                        }
                    } else {
                        return Single.just(ImportKeyResult.genericError)
                    }
                }
            }.catchErrorJustReturn(ImportKeyResult.genericError)
        }.catchErrorJustReturn(
            ImportKeyResult.invalidKey
        ).asObservable().startWith(ImportKeyResult.onProgress)
    }
}
