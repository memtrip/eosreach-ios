import UIKit
import RxSwift
import RxCocoa

class AccountNavigationViewController: MxViewController<AccountNavigationIntent, AccountNavigationResult, AccountNavigationViewState, AccountNavigationViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<AccountNavigationIntent> {
        return Observable.merge(
            Observable.just(AccountNavigationIntent.idle),
            Observable.just(AccountNavigationIntent.idle)
        )
    }

    override func idleIntent() -> AccountNavigationIntent {
        return AccountNavigationIntent.idle
    }

    override func render(state: AccountNavigationViewState) {
        switch state {
        case .idle:
            print("")
        case .onProgress:
            print("")
        case .onSuccess(let accountList):
            print("")
        case .onError:
            print("")
        case .noAccounts:
            print("")
        case .navigateToAccount(let accountEntity):
            print("")
        }
    }

    override func provideViewModel() -> AccountNavigationViewModel {
        return AccountNavigationViewModel(initialState: AccountNavigationViewState.idle)
    }
}
