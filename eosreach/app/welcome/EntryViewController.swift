import UIKit
import RxSwift
import RxCocoa

class EntryViewController: MxViewController<EntryIntent, EntryResult, EntryViewState, EntryViewModel> {

    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<EntryIntent> {
        return Observable.merge(
            Observable.just(EntryIntent.start),
            errorView.retryClick().map {
                return EntryIntent.start
            }
        )
    }

    override func idleIntent() -> EntryIntent {
        return EntryIntent.idle
    }

    override func render(state: EntryViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onError:
            activityIndicator.stop()
            errorView.visible()
            errorView.populate(body: R.string.welcomeStrings.welcome_entry_error_body())
        case .onRsaEncryptionFailed:
            activityIndicator.stop()
        case .navigateToSplash:
            performSegue(withIdentifier: R.segue.entryViewController.entryToSplash, sender: self)
        case .navigateToAccount(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.entryViewController.entryToAccount.identifier,
                model: AccountBundle(
                    accountName: accountName,
                    readOnly: false
                )
            ))
            performSegue(withIdentifier: R.segue.entryViewController.entryToAccount, sender: self)
        }
    }

    override func provideViewModel() -> EntryViewModel {
        return EntryViewModel(initialState: EntryViewState.idle)
    }
}
