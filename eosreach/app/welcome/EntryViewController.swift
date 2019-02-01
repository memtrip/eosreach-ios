import UIKit
import RxSwift
import RxCocoa

class EntryViewController: MxViewController<EntryIntent, EntryResult, EntryViewState, EntryViewModel> {

    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.publish(intent: EntryIntent.start)
    }

    override func intents() -> Observable<EntryIntent> {
        return Observable.merge(
            errorView.retryClick().map {
                EntryIntent.start
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
                    readOnly: false,
                    accountPage: AccountPage.balances
                )
            ))
            performSegue(withIdentifier: R.segue.entryViewController.entryToAccount, sender: self)
        }
    }

    override func provideViewModel() -> EntryViewModel {
        return EntryViewModel(initialState: EntryViewState.idle)
    }
    
    @IBAction func unwindToEntryViewController(segue: UIStoryboardSegue) {
        
    }
}
