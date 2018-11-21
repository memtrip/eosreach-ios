import Foundation
import RxSwift

class VoteViewModel: MxViewModel<VoteIntent, VoteResult, VoteViewState> {

    private let getAccoutByName = GetAccountByName()
    private let eosKeyManagerImpl = EosKeyManagerImpl()
    private let voteRequest = VoteRequestImpl()
    
    override func dispatcher(intent: VoteIntent) -> Observable<VoteResult> {
        switch intent {
        case .idle:
            return just(VoteResult.idle)
        case .start(let eosAccountVote):
            return just(populate(eosAccountVote: eosAccountVote))
        case .voteForUs(let accountName):
            return voteForUs(accountName: accountName)
        case .navigateToCastProducerVote:
            return just(VoteResult.navigateToCastProducerVote)
        case .navigateToCastProxyVote:
            return just(VoteResult.navigateToCastProxyVote)
        case .navigateToViewProducer(let accountName):
            return just(VoteResult.navigateToViewProducer(accountName: accountName))
        case .navigateToViewProxy(let accountName):
            return just(VoteResult.navigateToViewProxyVote(accountName: accountName))
        }
    }

    override func reducer(previousState: VoteViewState, result: VoteResult) -> VoteViewState {
        switch result {
        case .idle:
            return VoteViewState.idle
        case .populateProxyVote(let proxyAccountName):
            return VoteViewState.populateProxyVote(proxyAccountName: proxyAccountName)
        case .populateProducerVotes(let eosAccountVote):
            return VoteViewState.populateProducerVotes(eosAccountVote: eosAccountVote)
        case .noVoteCast:
            return VoteViewState.noVoteCast
        case .navigateToCastProducerVote:
            return VoteViewState.navigateToCastProducerVote
        case .navigateToCastProxyVote:
            return VoteViewState.navigateToCastProxyVote
        case .navigateToViewProducer(let accountName):
            return VoteViewState.navigateToViewProducer(accountName: accountName)
        case .navigateToViewProxyVote(let accountName):
            return VoteViewState.navigateToViewProxyVote(accountName: accountName)
        case .onVoteForUsProgress:
            return VoteViewState.onVoteForUsProgress
        case .onVoteForUsError(let log):
            return VoteViewState.onVoteForUsError(log: log)
        case .onVoteForUsGenericError:
            return VoteViewState.onVoteForUsGenericError
        case .onVoteForUsSuccess:
            return VoteViewState.onVoteForUsSuccess
        }
    }
    
    private func populate(eosAccountVote: EosAccountVote?) -> VoteResult {
        if (eosAccountVote != nil) {
            if (eosAccountVote!.hasDelegatedProxyVoter) {
                return VoteResult.populateProxyVote(proxyAccountName: eosAccountVote!.proxyVoterAccountName)
            } else if (eosAccountVote!.producers.isNotEmpty()) {
                return VoteResult.populateProducerVotes(eosAccountVote: eosAccountVote!)
            } else {
                return VoteResult.noVoteCast
            }
        } else {
            return VoteResult.noVoteCast
        }
    }
    
    private func voteForUs(accountName: String) -> Observable<VoteResult> {
        return getAccoutByName.select(accountName: accountName).flatMap { accountEntity in
            return self.eosKeyManagerImpl.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                return self.voteRequest.voteForProducer(voterAccountName: accountName, producers: [R.string.appStrings.app_block_producer_name()], authorizingPrivateKey: privateKey).map { result in
                    if (result.success()) {
                        return VoteResult.onVoteForUsSuccess
                    } else {
                        return self.voteForUsError(voteError: result.error!)
                    }
                }
            }
        }.asObservable().startWith(VoteResult.onVoteForUsProgress)
    }
    
    private func voteForUsError(voteError: VoteError) -> VoteResult {
        switch voteError {
        case .withLog(let body):
            return VoteResult.onVoteForUsError(log: body)
        case .generic:
            return VoteResult.onVoteForUsGenericError
        }
    }
}
