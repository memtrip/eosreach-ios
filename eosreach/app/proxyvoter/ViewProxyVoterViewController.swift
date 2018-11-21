import UIKit
import RxSwift
import RxCocoa

class ViewProxyVoterViewController
: MxViewController<ViewProxyVoterIntent, ViewProxyVoterResult, ViewProxyVoterViewState, ViewProxyVoterViewModel> {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var voterImageView: UIImageView!
    @IBOutlet weak var proxyVoterBlurb: UILabel!
    @IBOutlet weak var websiteButton: ReachButton!
    @IBOutlet weak var viewAccountButton: ReachButton!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var viewProxyContainer: UIView!
    
    var proxyVoterDetails: ProxyVoterDetails?
    
    private lazy var viewProxyVoterBundle = {
        return self.getDestinationBundle()!.model as! ViewProxyVoterBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        websiteButton.setTitle(R.string.blockProducerStrings.view_proxy_voter_website_button(), for: .normal)
        viewAccountButton.setTitle(R.string.blockProducerStrings.view_proxy_voter_account_button(), for: .normal)
    }

    override func intents() -> Observable<ViewProxyVoterIntent> {
        return Observable.merge(
            Observable.just(ViewProxyVoterIntent.start(viewProxyVoterBundle: viewProxyVoterBundle)),
            websiteButton.rx.tap.map {
                return ViewProxyVoterIntent.navigateToUrl(url: self.proxyVoterDetails!.website)
            },
            viewAccountButton.rx.tap.map {
                return ViewProxyVoterIntent.viewAccount(accountName: self.proxyVoterDetails!.owner)
            },
            errorView.retryClick().map {
                return ViewProxyVoterIntent.retry(viewProxyVoterBundle: self.viewProxyVoterBundle)
            }
        )
    }

    override func idleIntent() -> ViewProxyVoterIntent {
        return ViewProxyVoterIntent.idle
    }

    override func render(state: ViewProxyVoterViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(
                title: R.string.blockProducerStrings.view_proxy_voter_error_title(),
                body: R.string.blockProducerStrings.view_proxy_voter_error_body())
        case .populate(let proxyVoterDetails):
            self.proxyVoterDetails = proxyVoterDetails
            activityIndicator.stop()
            viewProxyContainer.visible()
            proxyVoterBlurb.text = proxyVoterDetails.slogan
            summaryTextView.text = proxyVoterDetails.philosophy
            toolBar.title = proxyVoterDetails.name
        case .onInvalidUrl(let url):
            showOKDialog(message: R.string.blockProducerStrings.view_proxy_voter_invalid_url(url))
        case .navigateToUrl(let url):
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
            }
        case .viewAccount(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.viewProxyVoterViewController.viewProxyVoterToAccount.identifier,
                model: AccountBundle(
                    accountName: accountName,
                    readOnly: true
                )
            ))
            performSegue(withIdentifier: R.segue.viewProxyVoterViewController.viewProxyVoterToAccount, sender: self)
        }
    }

    override func provideViewModel() -> ViewProxyVoterViewModel {
        return ViewProxyVoterViewModel(initialState: ViewProxyVoterViewState.idle)
    }
}
