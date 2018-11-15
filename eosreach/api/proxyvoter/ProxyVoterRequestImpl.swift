import Foundation
import RxSwift
import eosswift

class ProxyVoterRequestImpl : ProxyVoterRequest {

    let getRegProxyInfo = GetRegProxyInfo(chainApi: ChainApiFactory.create(rootUrl: R.string.appStrings.app_endpoint_url()))

    func getProxyVoters(nextAccount: String) -> Single<Result<[ProxyVoterDetails], ProxyVoterError>> {
        return getRegProxyInfo.getProxies(limit: 50, nextAccount: nextAccount).map { results in
            return Result(data: results.map { proxyJson in
                return ProxyVoterDetails(
                    owner: proxyJson.owner,
                    name: proxyJson.name,
                    website: proxyJson.website,
                    slogan: proxyJson.slogan,
                    philosophy: proxyJson.philosophy,
                    logo256: proxyJson.logo_256)
            })
        }.catchErrorJustReturn(Result(error: ProxyVoterError.genericError))
    }

    func getProxy(accountName: String) -> Single<Result<ProxyVoterDetails, ProxyVoterError>> {
        return getRegProxyInfo.getProxy(accountName: accountName).map { proxyJson in
            return Result(data: ProxyVoterDetails(
                owner: proxyJson.owner,
                name: proxyJson.name,
                website: proxyJson.website,
                slogan: proxyJson.slogan,
                philosophy: proxyJson.philosophy,
                logo256: proxyJson.logo_256))
        }.catchErrorJustReturn(Result(error: ProxyVoterError.genericError))
    }
}
