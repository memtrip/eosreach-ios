import UIKit
import RxSwift
import RxCocoa

class BalanceViewController: MxViewController<BalanceIntent, BalanceResult, BalanceViewState, BalanceViewModel>, DataTableView {

    typealias tableViewType = BalanceTableView

    @IBOutlet weak var scanForAirdrops: ReachButton!
    @IBOutlet weak var tokens: UILabel!
    @IBOutlet weak var noBalances: UILabel!
    @IBOutlet weak var balancesTableView: UITableView!
    
    var accountName: String?
    var accountBalanceList: AccountBalanceList?
    
    func dataTableView() -> BalanceTableView {
        return balancesTableView as! BalanceTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanForAirdrops.setTitle(R.string.accountStrings.account_balance_scan_for_airdrops_button(), for: .normal)
        tokens.text = R.string.accountStrings.account_balance_tokens_title()
    }

    override func intents() -> Observable<BalanceIntent> {
        return Observable.merge(
            Observable.just(BalanceIntent.start(accountBalances: accountBalanceList!)),
            scanForAirdrops.rx.tap.map {
                return BalanceIntent.scanForAirdropTokens(accountName: self.accountName!)
            },
            self.dataTableView().selected.map { contractAccountBalance in
                return BalanceIntent.navigateToActions(balance: contractAccountBalance)
            }
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
            dataTableView().visible()
            dataTableView().clear()
            dataTableView().populate(data: state.accountBalances.balances)
        case .navigateToActions(let contractAccountBalance):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.balanceViewController.balanceToActions.identifier,
                model: ActionsBundle(
                    contractAccountBalance: contractAccountBalance, readOnly: true)
            ))
            performSegue(withIdentifier: R.segue.balanceViewController.balanceToActions, sender: self)
        }
    }

    override func provideViewModel() -> BalanceViewModel {
        return BalanceViewModel(initialState: BalanceViewState(view: BalanceViewState.View.idle, accountBalances: AccountBalanceList(balances: [])))
    }
}
