import Foundation
import RxSwift
import eosswift

class VoteRequestImpl : VoteRequest {

    private let voteChain = VoteChain(chainApi: ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url()))

    func voteForProducer(
        voterAccountName: String,
        producers: [String],
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<VoteReceipt, VoteError>> {
        return voteChain.vote(
            args: VoteChain.Args(
                voter: voterAccountName,
                proxy: "",
                producers: producers),
            transactionContext: TransactionContext(
                authorizingAccountName: voterAccountName,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry())
        ).map { response in
            if (response.success) {
                return Result(data: VoteReceipt(transactionId: response.body!.transaction_id))
            } else {
                return Result(error: VoteError.withLog(body: response.errorBody!))
            }
        }.catchErrorJustReturn(Result(error: VoteError.generic))
    }

    func voteForProxy(
        voterAccountName: String,
        proxyVoteAccountName: String,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<VoteReceipt, VoteError>> {
        return voteChain.vote(
            args: VoteChain.Args(
                voter: voterAccountName,
                proxy: proxyVoteAccountName,
                producers: []),
            transactionContext: TransactionContext(
                authorizingAccountName: voterAccountName,
                authorizingPrivateKey: authorizingPrivateKey,
                expirationDate: Date.defaultTransactionExpiry())
            ).map { response in
                if (response.success) {
                    return Result(data: VoteReceipt(transactionId: response.body!.transaction_id))
                } else {
                    return Result(error: VoteError.withLog(body: response.errorBody!))
                }
            }.catchErrorJustReturn(Result(error: VoteError.generic))
    }
}
