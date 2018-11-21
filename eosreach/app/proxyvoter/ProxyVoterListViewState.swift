import Foundation

enum ProxyVoterListViewState: MxViewState {
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
