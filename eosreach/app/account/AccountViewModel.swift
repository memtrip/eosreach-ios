import Foundation
import RxSwift

class AccountViewModel: MxViewModel<AccountIntent, AccountResult, AccountViewState> {

    override func dispatcher(intent: AccountIntent) -> Observable<AccountResult> {
        switch intent {
        case .idle:
            fatalError()
        case .start(let accountBundle, let page):
            fatalError()
        case .balanceTabIdle:
            fatalError()
        case .resourceTabIdle:
            fatalError()
        case .voteTabIdle:
            fatalError()
        case .retry(let accountBundle):
            fatalError()
        case .refresh(let accountBundle):
            fatalError()
        }
    }

    override func reducer(previousState: AccountViewState, result: AccountResult) -> AccountViewState {
        switch result {
        case .balanceTabIdle:
            fatalError()
        case .resourceTabIdle:
            fatalError()
        case .voteTabIdle:
            fatalError()
        case .onProgress(let accountName):
            fatalError()
        case .onProgressWithStartingTab(let accountName, let page):
            fatalError()
        case .onSuccess(let accountView):
            fatalError()
        case .onErrorFetchingAccount:
            fatalError()
        case .onErrorFetchingBalances:
            fatalError()
        }
    }
}
