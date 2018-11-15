import Foundation
import RxSwift
import eosswift

protocol VoteRequest {

    func voteForProducer(
        voterAccountName: String,
        producers: [String],
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<VoteReceipt, VoteError>>

    func voteForProxy(
        voterAccountName: String,
        proxyVoteAccountName: String,
        authorizingPrivateKey: EOSPrivateKey
    ) -> Single<Result<VoteReceipt, VoteError>>
}

enum VoteError : ApiError {
    case withLog(body: String)
    case generic
}
