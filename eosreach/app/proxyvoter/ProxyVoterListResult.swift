import Foundation

enum ProxyVoterListResult: MxResult {
    case idle
    case onProgress
    case onError
    case onSuccess(proxyVoterDetails: [ProxyVoterDetails])
    case onMoreError
    case onMoreProgress
    case onMoreSuccess(proxyVoterDetails: [ProxyVoterDetails])
    case proxyInformationSelected(proxyVoterDetails: ProxyVoterDetails)
    case proxyVoterSelected(proxyVoterDetails: ProxyVoterDetails)
}
