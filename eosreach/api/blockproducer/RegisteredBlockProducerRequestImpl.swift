import Foundation
import RxSwift
import eosswift

class RegisteredBlockProducerRequestImpl : RegisteredBlockProducerRequest {

    private let chainApi = ChainApiModule.create()

    func getProducers(limit: Int, lowerLimit: String) -> Single<Result<[RegisteredBlockProducer], RegisteredBlockProducerError>> {
        return chainApi.getProducers(body: GetProducers(
            json: true,
            lower_bound: lowerLimit,
            limit: limit
        )).map { response in
            if (response.success) {
                let results = response.body!.rows
                if (results.count > 0) {
                    return Result(data: self.dropFirstItemWhenPaginationResult(
                        results: results.map { producer in
                            return RegisteredBlockProducer(
                                owner: producer.owner,
                                votesInEos: self.calculateEosFromVotes(votes: producer.total_votes),
                                producerKey: producer.producer_key,
                                isActive: producer.is_active,
                                url: producer.url)
                        },
                        lowerLimit: lowerLimit))
                } else {
                    return Result(error: RegisteredBlockProducerError.empty)
                }
            } else {
                return Result(error: RegisteredBlockProducerError.genericError)
            }
        }.catchErrorJustReturn(Result(error: RegisteredBlockProducerError.genericError))
    }

    private func calculateEosFromVotes(votes: String) -> String {
        let result = Int64(votes.split(separator: ".")[0])! / calculateVotesWeight() / 10000
        return result.delimiter
    }

    private func calculateVotesWeight() -> Int64 {
        let epoch = Double(946684800)
        let date = Date().timeIntervalSince1970 - epoch
        let weight = ceil(date / (86400 * 7)) / 52
        return Int64(pow(Double(2), weight))
    }

    private func dropFirstItemWhenPaginationResult(
        results: [RegisteredBlockProducer],
        lowerLimit: String
    ) -> [RegisteredBlockProducer] {
        if (lowerLimit != "") {
            return Array(results.dropFirst())
        } else {
            return results
        }
    }
}
