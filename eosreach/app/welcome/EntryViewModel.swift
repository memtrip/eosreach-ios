import Foundation
import RxSwift

class EntryViewModel: MxViewModel<EntryIntent, EntryResult, EntryViewState> {

    override func dispatcher(intent: EntryIntent) -> Observable<EntryResult> {
        switch intent {
        case .start:
            return just(EntryResult.navigateToSplash)
        case .idle:
            return just(EntryResult.idle)
        }
    }

    override func reducer(previousState: EntryViewState, result: EntryResult) -> EntryViewState {
        switch result {
        case .idle:
            return EntryViewState.idle
        case .onProgress:
            return EntryViewState.onProgress
        case .onError:
            return EntryViewState.onError
        case .onRsaEncryptionFailed:
            return EntryViewState.onRsaEncryptionFailed
        case .navigateToSplash:
            return EntryViewState.navigateToSplash
        case .navigateToAccount(let account):
            return EntryViewState.navigateToAccount(account: account)
        }
    }
}
