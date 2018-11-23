import UIKit
import RxSwift
import RxCocoa

class CastProxyVoteViewController: MxViewController<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState, CastProxyVoteViewModel>, ProxyVoterListDelegate {

    @IBOutlet weak var exploreProxyAccountsButton: ReachButton!
    @IBOutlet weak var proxyVoteAccountTextField: ReachTextField!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var voteButton: ReachButton!
    
    var accountName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exploreProxyAccountsButton.setTitle(R.string.voteStrings.cast_proxy_vote_explore_accounts_button(), for: .normal)
        proxyVoteAccountTextField.placeholder = R.string.voteStrings.cast_proxy_vote_placeholder()
        voteButton.setTitle(R.string.voteStrings.cast_proxy_vote_button(), for: .normal)
        let _ = proxyVoteAccountTextField.becomeFirstResponder()
    }

    override func intents() -> Observable<CastProxyVoteIntent> {
        return Observable.merge(
            Observable.just(CastProxyVoteIntent.idle),
            exploreProxyAccountsButton.rx.tap.map {
                CastProxyVoteIntent.navigateToExploreProxies()
            },
            Observable.merge(
                voteButton.rx.tap.asObservable(),
                proxyVoteAccountTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
            ).map {
                CastProxyVoteIntent.vote(
                    voterAccountName: self.accountName!,
                    proxyAccountName: self.proxyVoteAccountTextField.text!)
            }
        )
    }

    override func idleIntent() -> CastProxyVoteIntent {
        return CastProxyVoteIntent.idle
    }

    override func render(state: CastProxyVoteViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            voteButton.gone()
        case .onGenericError:
            activityIndicator.stop()
            voteButton.visible()
        case .onSuccess:
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.castProxyVoteViewController.castProxyVoteToAccount.identifier,
                model: AccountBundle(
                    accountName: accountName!,
                    readOnly: false,
                    accountPage: AccountPage.vote
                )
            ))
            performSegue(withIdentifier: R.segue.castProxyVoteViewController.castProxyVoteToAccount, sender: self)
        case .viewLog(let log):
            activityIndicator.stop()
            voteButton.visible()
            self.showTransactionLog(log: log)
        case .navigateToExploreProxies:
            performSegue(withIdentifier: R.segue.castProxyVoteViewController.castProxyVoteToProxyVoterList, sender: self)
        }
    }

    override func provideViewModel() -> CastProxyVoteViewModel {
        return CastProxyVoteViewModel(initialState: CastProxyVoteViewState.idle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == R.segue.castProxyVoteViewController.castProxyVoteToProxyVoterList.identifier) {
            (segue.destination as! ProxyVoterListViewController).delegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
    
    func onResult(proxyVoterDetails: ProxyVoterDetails) {
        proxyVoteAccountTextField.text = proxyVoterDetails.owner
    }
}
