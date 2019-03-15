import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: MxViewController<SettingsIntent, SettingsResult, SettingsViewState, SettingsViewModel>, SettingsDelegate {

    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var memtripButton: ReachButton!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPairButton: ReachNavigationButton!
    @IBOutlet weak var changeEosEndpoint: ReachNavigationButton!
    @IBOutlet weak var viewPrivateKeys: ReachNavigationButton!
    @IBOutlet weak var confirmedTransactions: ReachNavigationButton!
    @IBOutlet weak var joinUsOnTelegram: ReachNavigationButton!
    @IBOutlet weak var clearDataAndLogout: ReachNavigationButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.title = R.string.settingsStrings.settings_title()
        setToolbar(toolbar: toolbar)
        currencyPairButton.setTitle(R.string.settingsStrings.settings_navigation_currency_pair_button(), for: .normal)
        changeEosEndpoint.setTitle(R.string.settingsStrings.settings_navigation_eos_endpoint_button(), for: .normal)
        viewPrivateKeys.setTitle(R.string.settingsStrings.settings_navigation_private_keys_button(), for: .normal)
        confirmedTransactions.setTitle(R.string.settingsStrings.settings_navigation_confirmed_transactions_button(), for: .normal)
        joinUsOnTelegram.setTitle(R.string.settingsStrings.settings_navigation_join_us_on_telegram_button(), for: .normal)
        clearDataAndLogout.setTitle(R.string.settingsStrings.settings_navigation_clear_data_and_logout_button(), for: .normal)
    }

    override func intents() -> Observable<SettingsIntent> {
        return Observable.merge(
            Observable.just(SettingsIntent.start),
            currencyPairButton.rx.tap.map {
                SettingsIntent.navigateToCurrencyPairing
            },
            changeEosEndpoint.rx.tap.map {
                SettingsIntent.navigateToEosEndpoint
            },
            viewPrivateKeys.rx.tap.map {
                SettingsIntent.navigateToPrivateKeys
            },
            confirmedTransactions.rx.tap.map {
                SettingsIntent.navigateToViewConfirmedTransactions
            },
            joinUsOnTelegram.rx.tap.map {
                SettingsIntent.navigateToTelegram
            },
            clearDataAndLogout.rx.tap.map {
                SettingsIntent.requestClearDataAndLogout
            },
            memtripButton.rx.tap.map {
                SettingsIntent.navigateToAuthor
            },
            self.rx.methodInvoked(#selector(SettingsViewController.clearData)).map { _ in
                SettingsIntent.confirmClearDataAndLogout
            }
        )
    }

    override func idleIntent() -> SettingsIntent {
        return SettingsIntent.idle
    }

    override func render(state: SettingsViewState) {
        switch state {
        case .idle:
            break
        case .populate(let exchangeRateCurrency):
            currencyLabel.text = exchangeRateCurrency
        case .navigateToCurrencyPairing:
            performSegue(withIdentifier: R.segue.settingsViewController.settingsToCurrencyPairing, sender: self)
        case .navigateToEosEndpoint:
            performSegue(withIdentifier: R.segue.settingsViewController.settingsToEosEndpoint, sender: self)
        case .navigateToPrivateKeys:
            performSegue(withIdentifier: R.segue.settingsViewController.settingsToViewPrivateKeys, sender: self)
        case .navigateToViewConfirmedTransactions:
            performSegue(withIdentifier: R.segue.settingsViewController.settingsToTransactionHistory, sender: self)
        case .navigateToTelegram:
            if let url = URL(string: R.string.settingsStrings.settings_telegram_url()) {
                UIApplication.shared.open(url, options: [:])
            }
        case .confirmClearData:
            let alert = UIAlertController(
                title: R.string.settingsStrings.settings_clear_data_warning_dialog_title(),
                message: R.string.settingsStrings.settings_clear_data_warning_dialog_body(),
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.appStrings.app_dialog_ok(), style: .default, handler: { (option) in
                self.clearData()
            }))
            alert.addAction(UIAlertAction(title: R.string.appStrings.app_dialog_cancel(), style: .default, handler: nil))
            self.present(alert, animated: true)
        case .navigateToEntry:
            performSegue(withIdentifier: R.segue.settingsViewController.unwindToEntry, sender: self)
        case .navigateToAuthor:
            if let url = URL(string: R.string.settingsStrings.settings_author_website()) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    override func provideViewModel() -> SettingsViewModel {
        return SettingsViewModel(initialState: SettingsViewState.idle)
    }
    
    @objc dynamic func clearData() {
    }
    
    //
    // MARK :- SettingsDelegate
    //
    func currencyUpdate(symbol: String) {
        currencyLabel.text = symbol
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == R.segue.settingsViewController.settingsToCurrencyPairing.identifier) {
            (segue.destination as! CurrencyPairingViewController).delegate = self
        }
    }
}
