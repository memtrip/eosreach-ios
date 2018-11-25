import Foundation
import RxSwift

class CastProducersVoteViewModel: MxViewModel<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState> {
    
    private let voteRequest = VoteRequestImpl()
    
    override func dispatcher(intent: CastProducersVoteIntent) -> Observable<CastProducersVoteResult> {
        switch intent {
        case .idle:
            return just(CastProducersVoteResult.idle)
        case .start(let eosAccountVote):
            return just(populate(eosAccountVote: eosAccountVote))
        case .addProducerFromList:
            return just(CastProducersVoteResult.addProducerFromList)
        case .vote(let voterAccountName, let blockProducers):
            fatalError()
        case .addProducerField:
            return just(CastProducersVoteResult.addProducerField)
        case .viewLog(let log):
            fatalError()
        }
    }

    override func reducer(previousState: CastProducersVoteViewState, result: CastProducersVoteResult) -> CastProducersVoteViewState {
        switch result {
        case .idle:
            return CastProducersVoteViewState.idle
        case .onProgress:
            fatalError()
        case .addProducerFromList:
            return CastProducersVoteViewState.addProducerFromList
        case .addExistingProducers(let producers):
            return CastProducersVoteViewState.addExistingProducers(producers: producers)
        case .addProducerField:
            return CastProducersVoteViewState.addProducerField
        case .onGenericError:
            return CastProducersVoteViewState.onGenericError
        case .onSuccess:
            return CastProducersVoteViewState.onSuccess
        case .viewLog(let log):
            return CastProducersVoteViewState.viewLog(log: log)
        }
    }
    
    private func populate(eosAccountVote: EosAccountVote?) -> CastProducersVoteResult {
        if (eosAccountVote != nil && eosAccountVote!.producers.isNotEmpty()) {
            return CastProducersVoteResult.addExistingProducers(producers: eosAccountVote!.producers)
        } else {
            return CastProducersVoteResult.idle
        }
    }
}
