import Foundation
import RxSwift
import eosswift

class BlockProducerRequestImpl : BlockProducerRequest {

    private let blockProducers = GetBlockProducers(chainApi: ChainApiModule.create())

    func getBlockProducers(limit: Int) -> Single<Result<[BlockProducerDetails], BlockProducerError>> {
        return blockProducers.getProducers(limit: limit).map { blockProducers in
            return Result(data: blockProducers.map { blockProducer in
                BlockProducerDetails(
                    owner: blockProducer.bpJson.producer_account_name,
                    candidateName: blockProducer.bpJson.org.candidate_name,
                    apiUrl: blockProducer.apiEndpoint,
                    website: blockProducer.bpJson.org.website,
                    codeOfConductUrl: blockProducer.bpJson.org.code_of_conduct,
                    ownershipDisclosureUrl: blockProducer.bpJson.org.ownership_disclosure,
                    email: blockProducer.bpJson.org.email,
                    logo256: blockProducer.bpJson.org.branding.logo_256)
            })
        }.catchErrorJustReturn(Result(error: BlockProducerError.genericError))
    }

    func getSingleBlockProducer(accountName: String) -> Single<Result<BlockProducerDetails, BlockProducerError>> {
        return blockProducers.getSingleProducer(accountName: accountName).map { blockProducer in
            return Result(data: BlockProducerDetails(
                owner: blockProducer.bpJson.producer_account_name,
                candidateName: blockProducer.bpJson.org.candidate_name,
                apiUrl: blockProducer.apiEndpoint,
                website: blockProducer.bpJson.org.website,
                codeOfConductUrl: blockProducer.bpJson.org.code_of_conduct,
                ownershipDisclosureUrl: blockProducer.bpJson.org.ownership_disclosure,
                email: blockProducer.bpJson.org.email,
                logo256: blockProducer.bpJson.org.branding.logo_256))
        }.catchError { error in
            if (error is GetBlockProducerError) {
                let errorValue = error as! GetBlockProducerError
                switch (errorValue) {
                case .chainProducerJsonMissing:
                    return Single.just(Result(error: BlockProducerError.onChainProducerJsonMissing))
                case .failedToFetchBlockProducer:
                    return Single.just(Result(error: BlockProducerError.genericError))
                }
            } else {
                return Single.just(Result(error: BlockProducerError.genericError))
            }
        }
    }
}
