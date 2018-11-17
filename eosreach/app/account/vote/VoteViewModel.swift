import Foundation
import RxSwift

class VoteViewModel: MxViewModel<VoteIntent, VoteResult, VoteViewState> {

    override func dispatcher(intent: VoteIntent) -> Observable<VoteResult> {
        switch intent {
        case .idle:
            fatalError()
        case .start(let eosAccountVote):
            fatalError()
        case .voteForUs(let eosAccount):
            fatalError()
        case .navigateToCastProducerVote:
            fatalError()
        case .navigateToCastProxyVote:
            fatalError()
        case .navigateToViewProducer(let accountName):
            fatalError()
        case .navigateToViewProxy(let accountName):
            fatalError()
        }
    }

    override func reducer(previousState: VoteViewState, result: VoteResult) -> VoteViewState {
        switch result {
        case .idle:
            fatalError()
        case .populateProxyVote(let proxyAccountName):
            fatalError()
        case .populateProducerVotes(let eosAccountVote):
            fatalError()
        case .noVoteCast:
            fatalError()
        case .navigateToCastProducerVote:
            fatalError()
        case .navigateToCastProxyVote:
            fatalError()
        case .navigateToViewProducer(let accountName):
            fatalError()
        case .navigateToViewProxyVote(let accountName):
            fatalError()
        case .onVoteForUsProgress:
            fatalError()
        case .onVoteForUsError(let message, let log):
            fatalError()
        case .onVoteForUsSuccess:
            fatalError()
        }
    }
}
