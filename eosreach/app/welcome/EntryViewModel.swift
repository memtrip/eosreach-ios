import Foundation
import RxSwift

class EntryViewModel: MxViewModel<EntryIntent, EntryResult, EntryViewState> {

    private let eosKeyManager = EosKeyManagerImpl()
    private let countAccounts = CountAccounts()
    private let getAccountByName = GetAccountByName()
    private let accountListSelection = AccountListSelection()
    private let getAccounts = GetAccounts()
    
    override func dispatcher(intent: EntryIntent) -> Observable<EntryResult> {
        switch intent {
        case .start:
            return self.hasAccounts()
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
        case .navigateToAccount(let accountName):
            return EntryViewState.navigateToAccount(accountName: accountName)
        }
    }
    
    private func hasAccounts() -> Observable<EntryResult> {
        return countAccounts.count().flatMap { count in
            if (count > 0) {
                if (self.accountListSelection.get().isNotEmpty()) {
                    return self.getAccountByName.select(accountName: self.accountListSelection.get()).map { accountEntity in
                        return EntryResult.navigateToAccount(accountName: accountEntity.accountName)
                    }
                } else {
                    return self.getAccounts.select().map { accountEntity in
                        return EntryResult.navigateToAccount(accountName: accountEntity[0].accountName)
                    }
                }
            } else {
                return Single.just(EntryResult.navigateToSplash)
            }
        }.catchErrorJustReturn(EntryResult.onError).asObservable().startWith(EntryResult.onProgress)
    }
}
