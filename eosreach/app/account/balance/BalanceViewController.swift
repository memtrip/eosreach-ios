import UIKit
import RxSwift
import RxCocoa

class BalanceViewController: MxViewController<BalanceIntent, BalanceResult, BalanceViewState, BalanceViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<BalanceIntent> {
        return Observable.merge(
            Observable.just(BalanceIntent.idle),
            Observable.just(BalanceIntent.idle)
        )
    }

    override func idleIntent() -> BalanceIntent {
        return BalanceIntent.idle
    }

    override func render(state: BalanceViewState) {
        switch state.view {
        case .idle:
            print("")
        case .populate:
            print("")
        case .onAirdropError:
            print("")
        case .onAirdropProgress:
            print("")
        case .onAirdropSuccess:
            print("")
        case .navigateToCreateAccount:
            print("")
        case .navigateToActions(let contractAccountBalance):
            print("")
        }
    }

    override func provideViewModel() -> BalanceViewModel {
        return BalanceViewModel(initialState: BalanceViewState(view: BalanceViewState.View.idle, accountBalances: AccountBalanceList(balances: [])))
    }
}
