import Foundation
import RxSwift

class AccountViewModel: MxViewModel<AccountIntent, AccountResult, AccountViewState> {

    /*
     is AccountIntent.Init -> getAccount(intent.accountBundle.accountName)
     .startWith(AccountRenderAction.OnProgressWithStartingTab(
     intent.accountBundle.accountName,
     intent.page))
     is AccountIntent.Retry -> getAccount(intent.accountBundle.accountName)
     .startWith(AccountRenderAction.OnProgress(
     intent.accountBundle.accountName))
     is AccountIntent.Refresh -> getAccount(intent.accountBundle.accountName)
     .startWith(AccountRenderAction.OnProgress(
     intent.accountBundle.accountName))
     AccountIntent.BalanceTabIdle -> Observable.just(AccountRenderAction.BalanceTabIdle)
     AccountIntent.ResourceTabIdle -> Observable.just(AccountRenderAction.ResourceTabIdle)
     AccountIntent.VoteTabIdle -> Observable.just(AccountRenderAction.VoteTabIdle)
    */
    private func getAccount(accountName: String) -> Observable<AccountResult> {
        fatalError()
    }
    
    override func dispatcher(intent: AccountIntent) -> Observable<AccountResult> {
        switch intent {
        case .idle:
            return just(AccountResult.idle)
        case .start(let accountBundle, let page):
            return getAccount(accountName: accountBundle.accountName)
                .startWith(AccountResult.onProgressWithStartingTab(
                    accountName: accountBundle.accountName, page: page))
        case .retry(let accountBundle):
            return getAccount(accountName: accountBundle.accountName)
                .startWith(AccountResult.onProgress(accountName: accountBundle.accountName))
        case .refresh(let accountBundle):
            return getAccount(accountName: accountBundle.accountName)
                .startWith(AccountResult.onProgress(accountName: accountBundle.accountName))
        case .balanceTabIdle:
            return just(AccountResult.balanceTabIdle)
        case .resourceTabIdle:
            return just(AccountResult.resourceTabIdle)
        case .voteTabIdle:
            return just(AccountResult.voteTabIdle)
        }
    }

    override func reducer(previousState: AccountViewState, result: AccountResult) -> AccountViewState {
        switch result {
        case .idle:
            return previousState
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
