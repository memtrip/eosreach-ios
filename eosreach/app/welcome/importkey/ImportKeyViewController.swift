import UIKit
import RxSwift
import RxCocoa
import Material

class ImportKeyViewController: MxViewController<ImportKeyIntent, ImportKeyResult, ImportKeyViewState, ImportKeyViewModel> {

    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var privateKeyTextField: ReachTextField!
    @IBOutlet weak var privateKeyInstructionsLabel: UILabel!
    @IBOutlet weak var viewSourceButton: ReachButton!
    @IBOutlet weak var importKeyButton: ReachPrimaryButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!

    var toolbarSettingsMenuItem = IconButton(image: Icon.cm.settings, tintColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolbar)
        toolbar.title = R.string.welcomeStrings.welcome_import_key_title()
        toolbar.addRightItem(iconButton: toolbarSettingsMenuItem)
        privateKeyTextField.placeholder = R.string.welcomeStrings.welcome_import_key_private_key_placeholder()
        privateKeyInstructionsLabel.text = R.string.welcomeStrings.welcome_import_key_instructions_label()
        viewSourceButton.setTitle(R.string.welcomeStrings.welcome_import_key_view_source_button(), for: .normal)
        importKeyButton.setTitle(R.string.welcomeStrings.welcome_import_key_cta_button(), for: .normal)
    }

    override func intents() -> Observable<ImportKeyIntent> {
        return Observable.merge(
            Observable.just(ImportKeyIntent.idle),
            toolbarSettingsMenuItem.rx.tap.map {
                ImportKeyIntent.navigateToSettings
            },
            viewSourceButton.rx.tap.map {
                ImportKeyIntent.viewSource
            },
            Observable.merge(
                importKeyButton.rx.tap.asObservable(),
                privateKeyTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
            ).map {
                ImportKeyIntent.importKey(privateKey: self.privateKeyTextField.text!)
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
            importKeyButton.gone()
            activityIndicator.start()
        case .onSuccess:
            importKeyButton.gone()
            activityIndicator.stop()
            performSegue(withIdentifier: R.segue.importKeyViewController.importKeyUnwindToEntry, sender: self)
        case .genericError:
            showOKDialog(message: R.string.welcomeStrings.welcome_import_key_error_generic())
            importKeyButton.visible()
            activityIndicator.stop()
        case .noAccounts:
            showOKDialog(message: R.string.welcomeStrings.welcome_import_key_error_no_accounts())
            importKeyButton.visible()
            activityIndicator.stop()
        case .invalidKey:
            showOKDialog(message: R.string.welcomeStrings.welcome_import_key_error_invalid_key())
            importKeyButton.visible()
            activityIndicator.stop()
        case .navigateToGithubSource:
            if let url = URL(string: R.string.welcomeStrings.welcome_import_key_source_code_url()) {
                UIApplication.shared.open(url, options: [:])
            }
        case .navigateToSettings:
            performSegue(withIdentifier: R.segue.importKeyViewController.importPrivateKeyToSettings, sender: self)
        }
    }

    override func provideViewModel() -> ImportKeyViewModel {
        return ImportKeyViewModel(initialState: ImportKeyViewState.idle)
    }
}
