import UIKit
import RxSwift
import RxCocoa

class EntryViewController: MxViewController<EntryIntent, EntryResult, EntryViewState, EntryViewModel> {

    @IBOutlet weak var activityIndicator: ReachActivityIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<EntryIntent> {
        return Observable.merge(
            Observable.just(EntryIntent.start)
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
            activityIndicator.visible()
        case .onError:
            activityIndicator.gone()
        case .onRsaEncryptionFailed:
            activityIndicator.gone()
        case .navigateToSplash:
            performSegue(withIdentifier: R.segue.entryViewController.entryToSplash, sender: self)
        case .navigateToAccount(let account):
            print(account)
        }
    }

    override func provideViewModel() -> EntryViewModel {
        return EntryViewModel(initialState: EntryViewState.idle)
    }
}
