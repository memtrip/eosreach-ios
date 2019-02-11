import Foundation
import RxSwift

class CastProducersVoteViewModel: MxViewModel<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState> {
    
    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerFactory.create()
    private let insertTransactionLog = InsertTransactionLog()
    private let voteRequest = VoteRequestImpl()
    
    override func dispatcher(intent: CastProducersVoteIntent) -> Observable<CastProducersVoteResult> {
        switch intent {
        case .idle:
            return just(CastProducersVoteResult.idle)
        case .start(let eosAccountVote):
            return just(populate(eosAccountVote: eosAccountVote))
        case .vote(let voterAccountName, let blockProducers):
            return vote(voterAccountName: voterAccountName, blockProducers: blockProducers)
        case .addProducerFromList:
            return just(CastProducersVoteResult.addProducerFromList)
        case .addProducerField:
            return just(CastProducersVoteResult.addProducerField)
        }
    }

    override func reducer(previousState: CastProducersVoteViewState, result: CastProducersVoteResult) -> CastProducersVoteViewState {
        switch result {
        case .idle:
            return CastProducersVoteViewState.idle
        case .onProgress:
            return CastProducersVoteViewState.onProgress
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
    
    private func vote(voterAccountName: String, blockProducers: [String]) -> Observable<CastProducersVoteResult> {
        let sortedBlockProducers = blockProducers.sorted { $0 < $1 }
        return getAccountByName.select(accountName: voterAccountName).flatMap { accountEntity in
            return self.eosKeyManager.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                return self.voteRequest.voteForProducer(
                    voterAccountName: voterAccountName,
                    producers: sortedBlockProducers,
                    authorizingPrivateKey: privateKey
                ).flatMap { result in
                    if (result.success()) {
                        return self.insertTransactionLog.insert(
                            transactionId: result.data!.transactionId
                        ).map { _ in CastProducersVoteResult.onSuccess }
                    } else {
                        return Single.just(self.voteError(voteError: result.error!))
                    }
                }.catchErrorJustReturn(CastProducersVoteResult.onGenericError)
            }.catchErrorJustReturn(CastProducersVoteResult.onGenericError)
        }.catchErrorJustReturn(CastProducersVoteResult.onGenericError)
            .asObservable()
            .startWith(CastProducersVoteResult.onProgress)
    }
    
    private func voteError(voteError: VoteError) -> CastProducersVoteResult {
        switch voteError {
        case .withLog(let body):
            return CastProducersVoteResult.viewLog(log: body)
        case .generic:
            return CastProducersVoteResult.onGenericError
        }
    }
}
