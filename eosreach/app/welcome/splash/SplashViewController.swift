import UIKit
import RxSwift
import RxCocoa

class SplashViewController: MxViewController<SplashIntent, SplashResult, SplashViewState, SplashViewModel> {

    @IBOutlet weak var createAccountButton: ReachPrimaryButton!
    @IBOutlet weak var importPrivateKeyButton: ReachButton!
    @IBOutlet weak var exploreButton: ReachButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.setTitle(R.string.welcomeStrings.welcome_splash_create_account_button(), for: .normal)
        importPrivateKeyButton.setTitle(R.string.welcomeStrings.welcome_splash_import_private_key_button(), for: .normal)
        exploreButton.setTitle(R.string.welcomeStrings.welcome_splash_explore_button(), for: .normal)
    }

    override func intents() -> Observable<SplashIntent> {
        return Observable.merge(
            createAccountButton.rx.tap.map {
                SplashIntent.navigateToCreateAccount
            },
            importPrivateKeyButton.rx.tap.map {
                SplashIntent.navigateToImportPrivateKey
            },
            exploreButton.rx.tap.map {
                SplashIntent.navigateToExplore
            }
        )
    }

    override func idleIntent() -> SplashIntent {
        return SplashIntent.idle
    }

    override func render(state: SplashViewState) {
        switch state {
        case .idle:
            break
        case .navigateToCreateAccount:
            print("create account")
        case .navigateToImportPrivateKey:
            performSegue(withIdentifier: R.segue.splashViewController.splashToImportPrivateKey, sender: self)
        case .navigateToExplore:
            print("explore")
        }
    }

    override func provideViewModel() -> SplashViewModel {
        return SplashViewModel(initialState: SplashViewState.idle)
    }
}
