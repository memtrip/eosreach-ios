import Foundation
import RxSwift

class CastProxyVoteViewModel: MxViewModel<CastProxyVoteIntent, CastProxyVoteResult, CastProxyVoteViewState> {
    
    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerFactory.create()
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
                ).flatMap { result in
                    if (result.success()) {
                        return self.insertTransactionLog.insert(
                            transactionId: result.data!.transactionId
                        ).map { _ in CastProxyVoteResult.onSuccess }
                    } else {
                        return self.voteError(voteError: result.error!)
                    }
                }
            }
        }.asObservable()
            .catchErrorJustReturn(CastProxyVoteResult.onGenericError)
            .startWith(CastProxyVoteResult.onProgress)
    }
    
    private func voteError(voteError: VoteError) -> Single<CastProxyVoteResult> {
        switch voteError {
        case .withLog(let body):
            return Single.just(CastProxyVoteResult.viewLog(log: body))
        case .generic:
            return Single.just(CastProxyVoteResult.onGenericError)
        }
    }
}
