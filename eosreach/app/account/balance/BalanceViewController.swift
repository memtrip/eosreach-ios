import UIKit
import RxSwift
import RxCocoa

class BalanceViewController: MxViewController<BalanceIntent, BalanceResult, BalanceViewState, BalanceViewModel>, DataTableView {

    typealias tableViewType = BalanceTableView

    @IBOutlet weak var scanForAirdrops: ReachButton!
    @IBOutlet weak var tokens: UILabel!
    @IBOutlet weak var noBalances: UILabel!
    @IBOutlet weak var balancesTableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    
    var accountName: String?
    var accountBalanceList: AccountBalanceList?
    
    func dataTableView() -> BalanceTableView {
        return balancesTableView as! BalanceTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanForAirdrops.setTitle(R.string.accountStrings.account_balance_scan_for_airdrops_button(), for: .normal)
        tokens.text = R.string.accountStrings.account_balance_tokens_title()
        noBalances.text = R.string.accountStrings.account_balance_no_balance()
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
        case .emptyBalances:
            activityIndicator.stop()
            dataTableView().gone()
            noBalances.visible()
        case .populate:
            dataTableView().populate(data: state.accountBalances.balances)
        case .onAirdropError:
            activityIndicator.stop()
            dataTableView().visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.accountStrings.account_balance_airdrops_generic_error())
        case .onAirdropProgress:
            dataTableView().gone()
            activityIndicator.start()
        case .onAirdropSuccess:
            dataTableView().visible()
            dataTableView().clear()
            dataTableView().populate(data: state.accountBalances.balances)
        case .navigateToActions(let contractAccountBalance):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.balanceViewController.balanceToActions.identifier,
                model: ActionsBundle(
                    contractAccountBalance: contractAccountBalance, readOnly: false)
            ))
            performSegue(withIdentifier: R.segue.balanceViewController.balanceToActions, sender: self)
        case .onAirdropEmpty:
            activityIndicator.stop()
            dataTableView().visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.accountStrings.account_balance_airdrops_empty_error())
            break
        case .onAirdropCustomTokenTableEmpty:
            activityIndicator.stop()
            dataTableView().visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.accountStrings.account_balance_airdrops_customtoken_empty_error())
            break
        }
    }

    override func provideViewModel() -> BalanceViewModel {
        return BalanceViewModel(initialState: BalanceViewState(view: BalanceViewState.View.idle, accountBalances: AccountBalanceList(balances: [])))
    }
}
