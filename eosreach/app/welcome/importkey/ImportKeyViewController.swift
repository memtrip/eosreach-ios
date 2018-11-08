import UIKit
import RxSwift
import RxCocoa
import Material

class ImportKeyViewController: MxViewController<ImportKeyIntent, ImportKeyResult, ImportKeyViewState, ImportKeyViewModel> {

    @IBOutlet weak var toolbar: ReachToolbar!

    var toolbarSettingsMenuItem = IconButton(image: Icon.cm.settings, tintColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.title = R.string.welcomeStrings.welcome_import_key_title()
        setToolbar(toolbar: toolbar)

        toolbar.addRightItem(iconButton: toolbarSettingsMenuItem)
    }

    override func intents() -> Observable<ImportKeyIntent> {
        return Observable.merge(
            Observable.just(ImportKeyIntent.idle),
            toolbarSettingsMenuItem.rx.tap.map {
                ImportKeyIntent.navigateToSettings
            }
        )
    }

    override func idleIntent() -> ImportKeyIntent {
        return ImportKeyIntent.idle
    }

    override func render(state: ImportKeyViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            print("")
        case .onSuccess:
            print("")
        case .onError(let error):
            print("")
        case .navigateToGithubSource:
            print("")
        case .navigateToSettings:
            performSegue(withIdentifier: R.segue.importKeyViewController.importPrivateKeyToSettings, sender: self)
        }
    }

    override func provideViewModel() -> ImportKeyViewModel {
        return ImportKeyViewModel(initialState: ImportKeyViewState.idle)
    }
}
