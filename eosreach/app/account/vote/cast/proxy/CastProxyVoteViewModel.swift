import Foundation
import RxSwift

class CastProxyVoteViewModel: MxViewModel<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState> {
    
    override func dispatcher(intent: CastProxyVoteIntent) -> Observable<CastProxyVoteResult> {
        switch intent {
        case .idle:
            return just(CastProxyVoteResult.idle)
        }
    }
    
    override func reducer(previousState: CastProxyVoteViewState, result: CastProxyVoteResult) -> CastProxyVoteViewState {
        switch result {
        case .idle:
            return CastProxyVoteViewState.idle
        }
    }
}
