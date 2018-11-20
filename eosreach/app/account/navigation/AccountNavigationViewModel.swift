import Foundation
import RxSwift

class AccountNavigationViewModel: MxViewModel<AccountNavigationIntent, AccountNavigationResult, AccountNavigationViewState> {

    private let getAccounts = GetAccounts()
    private let accountListSelection = AccountListSelection()
    private let accountListUseCase = AccountNavigationUseCase()
    
    override func dispatcher(intent: AccountNavigationIntent) -> Observable<AccountNavigationResult> {
        switch intent {
        case .idle:
            fatalError()
        case .start:
            fatalError()
        case .accountSelected(let accountName):
            fatalError()
        case .refreshAccounts:
            fatalError()
        }
    }

    override func reducer(previousState: AccountNavigationViewState, result: AccountNavigationResult) -> AccountNavigationViewState {
        switch result {
        case .idle:
            fatalError()
        case .onProgress:
            fatalError()
        case .onSuccess(let accountList):
            fatalError()
        case .onError:
            fatalError()
        case .navigateToAccount(let accountEntity):
            fatalError()
        case .noAccounts:
            fatalError()
        }
    }
}
