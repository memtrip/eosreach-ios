import Foundation
import RxSwift

class AccountViewModel: MxViewModel<AccountIntent, AccountResult, AccountViewState> {

    private let accountUseCase = AccountUseCase()
    
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
        case .openNavigation:
            return just(AccountResult.openNavigation)
        case .navigateToExplore:
            return just(AccountResult.navigateToExplore)
        }
    }

    override func reducer(previousState: AccountViewState, result: AccountResult) -> AccountViewState {
        switch result {
        case .idle:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.idle
            })
        case .balanceTabIdle:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.idle
                copy.page = AccountPage.balances
            })
        case .resourceTabIdle:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.idle
                copy.page = AccountPage.resources
            })
        case .voteTabIdle:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.idle
                copy.page = AccountPage.vote
            })
        case .onProgress(let accountName):
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.onProgress
                copy.accountName = accountName
            })
        case .onProgressWithStartingTab(let accountName, let page):
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.onProgress
                copy.accountName = accountName
                copy.page = page
            })
        case .onSuccess(let accountView):
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.onSuccess
                copy.accountView = accountView
            })
        case .onErrorFetchingAccount:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.onErrorFetchingAccount
            })
        case .onErrorFetchingBalances:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.onErrorFetchingBalances
            })
        case .openNavigation:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.openNavigation
            })
        case .navigateToExplore:
            return previousState.copy(copy: { copy in
                copy.view = AccountViewState.View.navigateToExplore
            })
        }
    }
    
    private func getAccount(accountName: String) -> Observable<AccountResult> {
        return accountUseCase.getAccountDetails(
            contractName: "eosio.token",
            accountName: accountName
        ).map { accountView in
            if (accountView.success()) {
                return AccountResult.onSuccess(accountView: accountView)
            } else {
                return self.onError(error: accountView.error!)
            }
        }.asObservable().startWith(AccountResult.onProgress(accountName: accountName))
    }
    
    private func onError(error: AccountViewError) -> AccountResult {
        switch error {
        case .fetchingAccount:
            return AccountResult.onErrorFetchingAccount
        case .fetchingBalances:
            return AccountResult.onErrorFetchingBalances
        }
    }
}
