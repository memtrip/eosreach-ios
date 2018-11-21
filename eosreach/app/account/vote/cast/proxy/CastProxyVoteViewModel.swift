import Foundation
import RxSwift

class CastProxyVoteViewModel: MxViewModel<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState> {
    
    override func dispatcher(intent: CastProxyVoteIntent) -> Observable<CastProxyVoteResult> {
        switch intent {
        case .idle:
            return just(CastProxyVoteResult.idle)
        case .vote(let voterAccountName, let proxyAccountName):
            fatalError()
        case .viewLog(let log):
            return just(CastProxyVoteResult.viewLog(log: log))
        case .navigateToExploreProxies:
            return just(CastProxyVoteResult.navigateToExploreProxies)
        }
    }
    
    override func reducer(previousState: CastProxyVoteViewState, result: CastProxyVoteResult) -> CastProxyVoteViewState {
        switch result {
        case .idle:
            return CastProxyVoteViewState.idle
        case .onProgress:
            return CastProxyVoteViewState.onProgress
        case .onGenericError:
            return CastProxyVoteViewState.onGenericError
        case .onLogError(let log):
            return CastProxyVoteViewState.onLogError(log: log)
        case .onSuccess:
            return CastProxyVoteViewState.onSuccess
        case .viewLog(let log):
            return CastProxyVoteViewState.viewLog(log: log)
        case .navigateToExploreProxies:
            return CastProxyVoteViewState.navigateToExploreProxies
        }
    }
}
