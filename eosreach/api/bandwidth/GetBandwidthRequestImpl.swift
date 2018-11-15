import Foundation
import RxSwift
import eosswift

class GetBandwidthRequestImpl : GetBandwidthRequest {

    let getDelegatedBandwidth = GetDelegatedBandwidth(chainApi: ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url()))

    func getBandwidth(accountName: String) -> Single<Result<[DelegatedBandwidth], GetBandwidthError>> {
        return getDelegatedBandwidth.getBandwidth(accountName: accountName).map { results in
            if (results.count > 0) {
                return Result(data: results.map { bandwidthJson in
                    DelegatedBandwidth(
                        accountName: bandwidthJson.to,
                        netWeight: bandwidthJson.net_weight,
                        cpuWeight: bandwidthJson.cpu_weight)
                })
            } else {
                return Result(error: GetBandwidthError.empty)
            }
        }.catchErrorJustReturn(Result(error: GetBandwidthError.genericError))
    }
}
