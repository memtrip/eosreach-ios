import Foundation
import RxSwift

class CastProducersVoteViewModel: MxViewModel<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState> {
    
    override func dispatcher(intent: CastProducersVoteIntent) -> Observable<CastProducersVoteResult> {
        switch intent {
        case .idle:
            return just(CastProducersVoteResult.idle)
        }
    }

    override func reducer(previousState: CastProducersVoteViewState, result: CastProducersVoteResult) -> CastProducersVoteViewState {
        switch result {
        case .idle:
            return CastProducersVoteViewState.idle
        }
    }
}
