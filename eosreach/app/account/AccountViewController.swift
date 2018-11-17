import UIKit
import RxSwift
import RxCocoa

class AccountViewController: MxViewController<AccountIntent, AccountResult, AccountViewState, AccountViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<AccountIntent> {
        return Observable.merge(
            Observable.just(AccountIntent.idle),
            Observable.just(AccountIntent.idle)
        )
    }

    override func idleIntent() -> AccountIntent {
        return AccountIntent.idle
    }

    override func render(state: AccountViewState) {
        switch state.view {
        case .idle:
            print("")
        case .populate(let exchangeRateCurrency):
            print("")
        case .navigateToCurrencyPairing:
            print("")
        case .navigateToEosEndpoint:
            print("")
        case .navigateToPrivateKeys:
            print("")
        case .navigateToViewConfirmedTransactions:
            print("")
        case .navigateToTelegram:
            print("")
        case .confirmClearData:
            print("")
        case .navigateToEntry:
            print("")
        case .navigateToAuthor:
            print("")
        }
    }

    override func provideViewModel() -> AccountViewModel {
        return AccountViewModel(initialState: AccountViewState(view: AccountViewState.View.idle))
    }
}
