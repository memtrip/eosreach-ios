import UIKit
import RxSwift
import RxCocoa

class ViewActionViewController : MxViewController<ViewActionIntent, ViewActionResult, ViewActionViewState, ViewActionViewModel> {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelValue: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var viewInBlockExplorer: UIButton!
    @IBOutlet weak var viewInBlockExplorerButton: UIButton!
    @IBOutlet weak var memoTextField: UITextView!
    
    private lazy var viewActionBundle = {
        return self.getDestinationBundle()!.model as! ViewActionBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.accountStrings.account_view_action_title()
        amountLabel.text = R.string.accountStrings.account_view_action_amount_label()
        toLabel.text = R.string.accountStrings.account_view_action_to_label()
        fromLabel.text = R.string.accountStrings.account_view_action_from_label()
        dateLabel.text = R.string.accountStrings.account_view_action_date_label()
        memoLabel.text = R.string.accountStrings.account_view_action_memo_label()
        viewInBlockExplorerButton.setTitle(R.string.accountStrings.account_view_action_view_block_explorer_button(), for: .normal)
    }

    override func intents() -> Observable<ViewActionIntent> {
        return Observable.merge(
            Observable.just(ViewActionIntent.start(viewActionBundle: viewActionBundle)),
            viewInBlockExplorer.rx.tap.map {
                ViewActionIntent.viewTransactionBlockExplorer(transactionId: self.viewActionBundle.accountAction.tranactionId)
            },
            toButton.rx.tap.map {
                ViewActionIntent.navigateToAccount(accountName: self.toButton.titleLabel!.text!)
            },
            fromButton.rx.tap.map {
                ViewActionIntent.navigateToAccount(accountName: self.fromButton.titleLabel!.text!)
            }
        )
    }

    override func idleIntent() -> ViewActionIntent {
        return ViewActionIntent.idle
    }

    override func render(state: ViewActionViewState) {
        switch state {
        case .idle:
            break
        case .populate(let accountAction, let navigationAccount):
            amountValueLabel.text = R.string.accountStrings.account_view_action_amount_value(
                BalanceFormatter.formatEosBalance(balance: accountAction.quantity),
                CurrencyPairFormatter.formatAmountCurrencyPairValue(
                    amount: accountAction.quantity.amount,
                    eosPrice: accountAction.contractAccountBalance.exchangeRate))
            toButton.setTitle(accountAction.to, for: .normal)
            fromButton.setTitle(accountAction.from, for: .normal)
            dateLabelValue.text = accountAction.formattedDate
            memoTextField.text = accountAction.memo
            
            if (navigationAccount == accountAction.to) {
                toButton.setTitleColor(R.color.colorAccent(), for: .normal)
                toButton.isUserInteractionEnabled = true
                fromButton.isUserInteractionEnabled = false
            } else {
                fromButton.setTitleColor(R.color.colorAccent(), for: .normal)
                fromButton.isUserInteractionEnabled = true
                toButton.isUserInteractionEnabled = false
            }
        case .viewTransactionBlockExplorer(let transactionId):
            if let url = URL(string: R.string.transactionStrings.transaction_receipt_block_explorer_url(transactionId)) {
                UIApplication.shared.open(url, options: [:])
            }
        case .navigateToAccount(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.viewActionViewController.viewActionToAccount.identifier,
                model: AccountBundle(
                    accountName: accountName,
                    readOnly: true,
                    accountPage: AccountPage.balances
                )
            ))
            performSegue(withIdentifier: R.segue.viewActionViewController.viewActionToAccount, sender: self)
        }
    }

    override func provideViewModel() -> ViewActionViewModel {
        return ViewActionViewModel(initialState: ViewActionViewState.idle)
    }
}
