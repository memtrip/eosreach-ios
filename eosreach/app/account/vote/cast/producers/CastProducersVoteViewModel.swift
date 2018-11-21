import Foundation
import RxSwift

class CastProducersVoteViewModel: MxViewModel<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState> {
    
    override func dispatcher(intent: CastProducersVoteIntent) -> Observable<CastProducersVoteResult> {
        switch intent {
        case .idle:
            return just(CastProducersVoteResult.idle)
        case .start(let eosAccountVote):
            fatalError()
        case .vote(let voterAccountName, let blockProducers):
            fatalError()
        case .addProducerField(let nextPosition, let currentTotal):
            fatalError()
        case .insertProducerField(let nextPosition, let currentTotal, let producerName):
            fatalError()
        case .removeProducerField(let removePosition):
            fatalError()
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
        case .addExistingProducers(let producers):
            fatalError()
        case .addProducerField(let nextPosition):
            fatalError()
        case .removeProducerField(let position):
            fatalError()
        case .insertProducerField(let nextPosition, let producerName):
            fatalError()
        case .onGenericError:
            fatalError()
        case .onSuccess:
            fatalError()
        case .viewLog(let log):
            fatalError()
        }
    }
}
