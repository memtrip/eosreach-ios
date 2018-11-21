import Foundation
import RxSwift

class CastProxyVoteViewModel: MxViewModel<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState> {
    
    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerImpl()
    private let voteRequest = VoteRequestImpl()
    private let insertTransactionLog = InsertTransactionLog()
    
    override func dispatcher(intent: CastProxyVoteIntent) -> Observable<CastProxyVoteResult> {
        switch intent {
        case .idle:
            return just(CastProxyVoteResult.idle)
        case .vote(let voterAccountName, let proxyAccountName):
            return giveProxyVote(voterAccountName: voterAccountName, proxyVoteAccountName: proxyAccountName)
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
        case .onSuccess:
            return CastProxyVoteViewState.onSuccess
        case .viewLog(let log):
            return CastProxyVoteViewState.viewLog(log: log)
        case .navigateToExploreProxies:
            return CastProxyVoteViewState.navigateToExploreProxies
        }
    }
    
    private func giveProxyVote(voterAccountName: String, proxyVoteAccountName: String) -> Observable<CastProxyVoteResult> {
        return getAccountByName.select(accountName: voterAccountName).flatMap { accountEntity in
            return self.eosKeyManager.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                return self.voteRequest.voteForProxy(
                    voterAccountName: voterAccountName,
                    proxyVoteAccountName: proxyVoteAccountName,
                    authorizingPrivateKey: privateKey
                ).map { result in
                    if (result.success()) {
                        // TODO: transaction log
                        return CastProxyVoteResult.onSuccess
                    } else {
                        return CastProxyVoteResult.onGenericError
                    }
                }
            }
        }.asObservable()
            .catchErrorJustReturn(CastProxyVoteResult.onGenericError)
            .startWith(CastProxyVoteResult.onProgress)
    }
}
