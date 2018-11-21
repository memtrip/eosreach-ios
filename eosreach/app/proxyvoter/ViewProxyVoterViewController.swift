import UIKit
import RxSwift
import RxCocoa

class ViewProxyVoterViewController
: MxViewController<ViewProxyVoterIntent, ViewProxyVoterResult, ViewProxyVoterViewState, ViewProxyVoterViewModel> {
    
    private lazy var viewProxyVoterBundle = {
        return self.getDestinationBundle()!.model as! ViewProxyVoterBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setToolbar(toolbar: toolBar)
//        ownerAccountButton.setTitle(R.string.ProxyVoterStrings.view_block_producer_owner_account_button(), for: .normal)
//        codeOfConductButton.setTitle(R.string.ProxyVoterStrings.view_block_producer_code_of_conduct(), for: .normal)
//        ownershipDisclosureButton.setTitle(R.string.ProxyVoterStrings.view_block_producer_ownership_disclosure(), for: .normal)
    }

    override func intents() -> Observable<ViewProxyVoterIntent> {
        return Observable.merge(
            Observable.just(ViewProxyVoterIntent.start(
                viewProxyVoterBundle: viewProxyVoterBundle)
            )
        )
    }

    override func idleIntent() -> ViewProxyVoterIntent {
        return ViewProxyVoterIntent.idle
    }

    override func render(state: ViewProxyVoterViewState) {
        switch state {
        case .idle:
            print("")
        case .onProgress:
            print("")
        case .onError:
            print("")
        case .populate(let proxyVoterDetails):
            print("")
        case .onInvalidUrl(let url):
            print("")
        case .navigateToUrl(let url):
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    override func provideViewModel() -> ViewProxyVoterViewModel {
        return ViewProxyVoterViewModel(initialState: ViewProxyVoterViewState.idle)
    }
}
