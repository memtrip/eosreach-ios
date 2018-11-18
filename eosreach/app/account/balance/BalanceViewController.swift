import UIKit
import RxSwift
import RxCocoa

class BalanceViewController: MxViewController<BalanceIntent, BalanceResult, BalanceViewState, BalanceViewModel>, DataTableView {

    typealias tableViewType = BalanceTableView

    @IBOutlet weak var scanForAirdrops: ReachButton!
    @IBOutlet weak var tokens: UILabel!
    @IBOutlet weak var noBalances: UILabel!
    @IBOutlet weak var balancesTableView: UITableView!
    
    func dataTableView() -> BalanceTableView {
        return balancesTableView as! BalanceTableView
    }
    
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
            break
        case .populate:
            dataTableView().populate(data: state.accountBalances.balances)
        case .onAirdropError:
            print("")
        case .onAirdropProgress:
            print("")
        case .onAirdropSuccess:
            print("")
        case .navigateToActions(let contractAccountBalance):
            print("")
        }
    }

    override func provideViewModel() -> BalanceViewModel {
        return BalanceViewModel(initialState: BalanceViewState(view: BalanceViewState.View.idle, accountBalances: AccountBalanceList(balances: [])))
    }
}
