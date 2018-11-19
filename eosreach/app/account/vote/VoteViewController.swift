import UIKit
import RxSwift
import RxCocoa

class VoteViewController: MxViewController<VoteIntent, VoteResult, VoteViewState, VoteViewModel> {

    @IBOutlet weak var castVoteTitleLabel: UILabel!
    @IBOutlet weak var producerButton: ReachButton!
    @IBOutlet weak var proxyButton: ReachButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castVoteTitleLabel.text = R.string.accountStrings.account_vote_cast_vote_title()
        producerButton.setTitle(R.string.accountStrings.account_vote_producer_button(), for: .normal)
        proxyButton.setTitle(R.string.accountStrings.account_vote_proxy_button(), for: .normal)
    }

    override func intents() -> Observable<VoteIntent> {
        return Observable.merge(
            Observable.just(VoteIntent.idle),
            producerButton.rx.tap.map {
                return VoteIntent.navigateToCastProducerVote
            },
            proxyButton.rx.tap.map {
                return VoteIntent.navigateToCastProxyVote
            }
        )
    }

    override func idleIntent() -> VoteIntent {
        return VoteIntent.idle
    }

    override func render(state: VoteViewState) {
        switch state {
        case .idle:
            break
        case .populateProxyVote(let proxyAccountName):
            print("")
        case .populateProducerVotes(let eosAccountVote):
            print("")
        case .noVoteCast:
            print("")
        case .navigateToCastProducerVote:
            print("")
        case .navigateToCastProxyVote:
            print("")
        case .navigateToViewProducer(let accountName):
            print("")
        case .navigateToViewProxyVote(let accountName):
            print("")
        case .onVoteForUsProgress:
            print("")
        case .onVoteForUsSuccess:
            print("")
        case .onVoteForUsError(let log):
            print("")
        case .onVoteForUsGenericError:
            print("")
        }
    }

    override func provideViewModel() -> VoteViewModel {
        return VoteViewModel(initialState: VoteViewState.idle)
    }
}
