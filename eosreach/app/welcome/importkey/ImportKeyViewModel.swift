import Foundation
import RxSwift
import eosswift

class ImportKeyViewModel: MxViewModel<ImportKeyIntent, ImportKeyResult, ImportKeyViewState> {

    let eosKeyManager = EosKeyManagerFactory.create()

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
        case .onError(let error):
            return ImportKeyViewState.onError(error: error)
        case .navigateToGithubSource:
            return ImportKeyViewState.navigateToGithubSource
        case .navigateToSettings:
            return ImportKeyViewState.navigateToSettings
        }
    }

    private func importKey(privateKey: String) -> Observable<ImportKeyResult> {
        return eosKeyManager.createEosPrivateKey(value: privateKey).flatMap { eosPrivateKey in
            self.eosKeyManager.importPrivateKey(eosPrivateKey: eosPrivateKey).flatMap { publicKey in
                Single.just(ImportKeyResult.onError(error: R.string.welcomeStrings.welcome_import_key_error_generic()))
            }.catchErrorJustReturn(
                ImportKeyResult.onError(error: R.string.welcomeStrings.welcome_import_key_error_generic())
            )
        }.catchErrorJustReturn(
            ImportKeyResult.onError(error: R.string.welcomeStrings.welcome_import_key_error_invalid_key())
        ).asObservable().startWith(ImportKeyResult.onProgress)
    }
}
