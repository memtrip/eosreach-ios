import UIKit
import RxSwift
import RxCocoa

class VoteViewController: MxViewController<VoteIntent, VoteResult, VoteViewState, VoteViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<VoteIntent> {
        return Observable.merge(
            Observable.just(VoteIntent.idle),
            Observable.just(VoteIntent.idle)
        )
    }

    override func idleIntent() -> VoteIntent {
        return VoteIntent.idle
    }

    override func render(state: VoteViewState) {
        switch state {
        case .idle:
            print("")
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
        case .onVoteForUsError(let message, let log):
            print("")
        }
    }

    override func provideViewModel() -> VoteViewModel {
        return VoteViewModel(initialState: VoteViewState.idle)
    }
}
