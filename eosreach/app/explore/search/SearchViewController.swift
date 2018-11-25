import UIKit
import RxSwift
import RxCocoa

class SearchViewController: MxViewController<SearchIntent, SearchResult, SearchViewState, SearchViewModel>, DataTableView {
    
    typealias tableViewType = AccountCardTableView
    
    @IBOutlet weak var searchTextField: ReachTextField!
    @IBOutlet weak var accountCardTableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    func dataTableView() -> AccountCardTableView {
        return accountCardTableView as! AccountCardTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = R.string.exploreStrings.explore_search_textfield_placeholder()
        let _ = searchTextField.becomeFirstResponder()
    }

    override func intents() -> Observable<SearchIntent> {
        return Observable.merge(
            Observable.just(SearchIntent.idle),
            searchTextField.rx.text
                .asObservable()
                .map { terms in SearchIntent.searchValueChanged(searchValue: terms!) },
            searchTextField.rx.controlEvent(.editingDidEndOnExit).map {
                self.view.endEditing(true)
                return SearchIntent.idle
            },
            errorView.retryClick().map {
                return SearchIntent.searchValueChanged(searchValue: self.searchTextField.text!)
            },
            dataTableView().selected.map { accountCardModel in
                return SearchIntent.viewAccount(accountCardModel: accountCardModel)
            }
        )
    }

    override func idleIntent() -> SearchIntent {
        return SearchIntent.idle
    }

    override func render(state: SearchViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
            dataTableView().gone()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(body: R.string.exploreStrings.explore_search_error_body())
        case .onSuccess(let accountModel):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().clear()
            dataTableView().populate(data: [accountModel])
        case .viewAccount(let accountModel):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.searchViewController.searchToAccount.identifier,
                model: AccountBundle(
                    accountName: accountModel.accountName,
                    readOnly: true,
                    accountPage: AccountPage.balances)
            ))
            performSegue(withIdentifier: R.segue.searchViewController.searchToAccount, sender: self)
        }
    }

    override func provideViewModel() -> SearchViewModel {
        return SearchViewModel(initialState: SearchViewState.idle)
    }
}
