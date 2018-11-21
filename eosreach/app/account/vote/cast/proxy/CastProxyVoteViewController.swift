import UIKit
import RxSwift
import RxCocoa

class CastProxyVoteViewController: MxViewController<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState, CastProxyVoteViewModel> {

    @IBOutlet weak var exploreProxyAccountsButton: ReachButton!
    @IBOutlet weak var proxyVoteAccountTextField: ReachTextField!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var voteButton: ReachButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exploreProxyAccountsButton.setTitle(R.string.voteStrings.cast_proxy_vote_explore_accounts_button(), for: .normal)
        proxyVoteAccountTextField.placeholder = R.string.voteStrings.cast_proxy_vote_placeholder()
        voteButton.setTitle(R.string.voteStrings.cast_proxy_vote_button(), for: .normal)
    }

    override func intents() -> Observable<CastProxyVoteIntent> {
        return Observable.merge(
            Observable.just(CastProxyVoteIntent.idle)
        )
    }

    override func idleIntent() -> CastProxyVoteIntent {
        return CastProxyVoteIntent.idle
    }

    override func render(state: CastProxyVoteViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> CastProxyVoteViewModel {
        return CastProxyVoteViewModel(initialState: CastProxyVoteViewState.idle)
    }
}
