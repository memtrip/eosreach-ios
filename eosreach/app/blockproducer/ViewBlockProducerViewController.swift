import UIKit
import RxSwift
import RxCocoa

class ViewBlockProducerViewController
: MxViewController<ViewBlockProducerIntent, ViewBlockProducerResult, ViewBlockProducerViewState, ViewBlockProducerViewModel> {
        
    @IBOutlet weak var blockProducerImage: UIImageView!
    
    @IBOutlet weak var toolBar: ReachToolbar!
    
    @IBOutlet weak var ownerAccountButton: ReachPrimaryButton!
    @IBOutlet weak var codeOfConductButton: ReachButton!
    @IBOutlet weak var ownershipDisclosureButton: ReachButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var blockProducerContainer: UIView!
    @IBOutlet weak var noProducers: UILabel!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    var blockProducerDetails: BlockProducerDetails?
    
    private lazy var viewBlockProducerBundle = {
        return self.getDestinationBundle()!.model as! ViewBlockProducerBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        ownerAccountButton.setTitle(R.string.blockProducerStrings.view_block_producer_owner_account_button(), for: .normal)
        codeOfConductButton.setTitle(R.string.blockProducerStrings.view_block_producer_code_of_conduct(), for: .normal)
        ownershipDisclosureButton.setTitle(R.string.blockProducerStrings.view_block_producer_ownership_disclosure(), for: .normal)
    }

    override func intents() -> Observable<ViewBlockProducerIntent> {
        return Observable.merge(
            Observable.just(ViewBlockProducerIntent.start(
                accountName: viewBlockProducerBundle.accountName,
                blockProducerDetails: viewBlockProducerBundle.blockProducerDetails
            )),
            ownerAccountButton.rx.tap.map {
                ViewBlockProducerIntent.navigateToOwnerAccount(owner: self.blockProducerDetails!.owner)
            },
            codeOfConductButton.rx.tap.map {
                ViewBlockProducerIntent.navigateToUrl(url: self.blockProducerDetails!.codeOfConductUrl)
            },
            ownershipDisclosureButton.rx.tap.map {
                ViewBlockProducerIntent.navigateToUrl(url: self.blockProducerDetails!.ownershipDisclosureUrl)
            },
            websiteButton.rx.tap.map {
                ViewBlockProducerIntent.navigateToUrl(url: self.blockProducerDetails!.website)
            },
            emailButton.rx.tap.map {
                ViewBlockProducerIntent.sendEmail(email: self.blockProducerDetails!.email)
            },
            errorView.retryClick().map {
                ViewBlockProducerIntent.start(
                    accountName: self.viewBlockProducerBundle.accountName,
                    blockProducerDetails: self.viewBlockProducerBundle.blockProducerDetails)
            }
        )
    }

    override func idleIntent() -> ViewBlockProducerIntent {
        return ViewBlockProducerIntent.idle
    }

    override func render(state: ViewBlockProducerViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(body: R.string.blockProducerStrings.view_block_producer_error_body())
        case .empty:
            activityIndicator.stop()
            noProducers.visible()
            noProducers.text = R.string.blockProducerStrings.view_block_producer_empty()
        case .onInvalidUrl(let url):
            showOKDialog(message: R.string.blockProducerStrings.view_block_producer_invalid_url(url))
        case .navigateToUrl(let url):
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:])
            }
        case .populate(let blockProducerDetails):
            self.blockProducerDetails = blockProducerDetails
            activityIndicator.stop()
            blockProducerContainer.visible()
            toolBar.title = blockProducerDetails.candidateName
            websiteButton.setTitle(blockProducerDetails.website, for: .normal)
            emailButton.setTitle(blockProducerDetails.email, for: .normal)
            // TODO: populate image
        case .sendEmail(let email):
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        case .navigateToOwnerAccount(let owner):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.viewBlockProducerViewController.viewProducerToAccount.identifier,
                model: AccountBundle(
                    accountName: owner,
                    readOnly: true
                )
            ))
            performSegue(withIdentifier: R.segue.viewBlockProducerViewController.viewProducerToAccount, sender: self)
        }
    }

    override func provideViewModel() -> ViewBlockProducerViewModel {
        return ViewBlockProducerViewModel(initialState: ViewBlockProducerViewState.idle)
    }
}
