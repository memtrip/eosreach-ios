import Foundation
import RxSwift

class AccountNavigationViewModel: MxViewModel<AccountNavigationIntent, AccountNavigationResult, AccountNavigationViewState> {

    private let getAccounts = GetAccounts()
    private let accountListSelection = AccountListSelection()
    private let accountListUseCase = AccountNavigationUseCase()
    
    override func dispatcher(intent: AccountNavigationIntent) -> Observable<AccountNavigationResult> {
        switch intent {
        case .idle:
            return just(AccountNavigationResult.idle)
        case .start:
            return getCachedAccounts().asObservable().startWith(AccountNavigationResult.onProgress)
        case .accountSelected(let accountName):
            return self.accountSelected(accountName: accountName)
        case .refreshAccounts:
            return refreshAccounts()
        case .navigateToImportKey:
            return just(AccountNavigationResult.navigateToImportKey)
        case .navigateToCreateAccount:
            return just(AccountNavigationResult.navigateToCreateAccount)
        case .navigateToSettings:
            return just(AccountNavigationResult.navigateToSettings)
        }
    }

    override func reducer(previousState: AccountNavigationViewState, result: AccountNavigationResult) -> AccountNavigationViewState {
        switch result {
        case .idle:
            return AccountNavigationViewState.idle
        case .onProgress:
            return AccountNavigationViewState.onProgress
        case .onSuccess(let accountModelList):
            return AccountNavigationViewState.onSuccess(accountList: accountModelList)
        case .onError:
            return AccountNavigationViewState.onError
        case .navigateToAccount(let accountName):
            return AccountNavigationViewState.navigateToAccount(accountName: accountName)
        case .noAccounts:
            return AccountNavigationViewState.noAccounts
        case .navigateToImportKey:
            return AccountNavigationViewState.navigateToImportKey
        case .navigateToCreateAccount:
            return AccountNavigationViewState.navigateToCreateAccount
        case .navigateToSettings:
            return AccountNavigationViewState.navigateToSettings
        }
    }
    
    private func getCachedAccounts() -> Single<AccountNavigationResult> {
        return getAccounts.select().map { accounts in
            if (accounts.isEmpty) {
                return AccountNavigationResult.noAccounts
            } else {
                return AccountNavigationResult.onSuccess(accountModelList: accounts)
            }
        }
    }
    
    private func accountSelected(accountName: String) -> Observable<AccountNavigationResult> {
        accountListSelection.put(value: accountName)
        return Observable.just(AccountNavigationResult.navigateToAccount(accountName: accountName))
    }
    
    private func refreshAccounts() -> Observable<AccountNavigationResult> {
        accountListSelection.clear()
        return accountListUseCase
            .refreshAccounts()
            .flatMap { result in
                if (result.success()) {
                    return self.getCachedAccounts()
                } else {
                    return self.refreshAccountsError(error: result.error!)
                }
            }
            .catchErrorJustReturn(AccountNavigationResult.onError)
            .asObservable()
            .startWith(AccountNavigationResult.onProgress)
    }
    
    private func refreshAccountsError(error: AccountsListError) -> Single<AccountNavigationResult> {
        switch error {
        case .refreshAccountsFailed:
            return Single.just(AccountNavigationResult.onError)
        case .noAccounts:
            return Single.just(AccountNavigationResult.noAccounts)
        }
    }
}
