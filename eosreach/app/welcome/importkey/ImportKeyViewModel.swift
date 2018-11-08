import Foundation
import RxSwift

class ImportKeyViewModel: MxViewModel<ImportKeyIntent, ImportKeyResult, ImportKeyViewState> {

    override func dispatcher(intent: ImportKeyIntent) -> Observable<ImportKeyResult> {
        switch intent {
        case .idle:
            return just(ImportKeyResult.idle)
        case .importKey(let privateKey):
            fatalError()
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
}
