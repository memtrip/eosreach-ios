import UIKit
import RxSwift
import RxCocoa
import StoreKit

class CreateAccountViewController: MxViewController<CreateAccountIntent, CreateAccountResult, CreateAccountViewState, CreateAccountViewModel>, BillingFlowDelegate, BillingConnectionDelegate {

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var skProductNotFound: UILabel!
    
    @IBOutlet weak var formViewGroup: UIView!
    @IBOutlet weak var formAccountTextField: ReachTextField!
    @IBOutlet weak var formInstructionLabel: UILabel!
    @IBOutlet weak var formNetCpuResources: ReachNetCpuView!
    @IBOutlet weak var formCtaActivityIndicator: ReachActivityIndicator!
    @IBOutlet weak var formCtaButton: ReachPrimaryButton!
    
    @IBOutlet weak var doneViewGroup: UIView!
    @IBOutlet weak var doneCreateAccountLabel: UILabel!
    @IBOutlet weak var doneInstructionLabel: UILabel!
    @IBOutlet weak var doneCtaButton: ReachPrimaryButton!
    @IBOutlet weak var donePrivateKeyTextView: ReachTextView!
    
    @IBOutlet weak var limboViewGroup: UIView!
    @IBOutlet weak var limboTitle: UILabel!
    @IBOutlet weak var limboBody: UILabel!
    @IBOutlet weak var limboGoToSettingsButton: ReachPrimaryButton!
    @IBOutlet weak var limboRetryButton: ReachPrimaryButton!
    
    @IBOutlet weak var importKeyGroup: UIView!
    @IBOutlet weak var importKeyInstructionLabel: UILabel!
    @IBOutlet weak var importKeySyncButton: ReachPrimaryButton!
    @IBOutlet weak var importKeyGoToSettings: UIButton!
    
    private var skProduct: SKProduct?
    private var createBilling: Billing?
    
    private lazy var billing: Billing = {
        return createBilling!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.welcomeStrings.create_account_title()
        formAccountTextField.placeholder = R.string.welcomeStrings.create_account_account_name_placeholder()
        formInstructionLabel.text = R.string.welcomeStrings.create_account_resource_instructions()
        formNetCpuResources.cpuValueLabel.text = R.string.welcomeStrings.create_account_resource_cpu()
        formNetCpuResources.netValueLabel.text = R.string.welcomeStrings.create_account_resource_net()
        formCtaButton.setTitle(R.string.welcomeStrings.create_account_cta_button(R.string.appStrings.app_empty_value()), for: .normal)
        skProductNotFound.text = R.string.welcomeStrings.create_account_sku_error()
        
        doneCreateAccountLabel.text = R.string.welcomeStrings.create_account_done_title()
        doneInstructionLabel.text = R.string.welcomeStrings.create_account_done_instructions()
        doneCtaButton.setTitle(R.string.welcomeStrings.create_account_done_button(), for: .normal)
        
        limboTitle.text = R.string.welcomeStrings.create_account_limbo_error_title()
        limboBody.text = R.string.welcomeStrings.create_account_limbo_error_body()
        limboGoToSettingsButton.setTitle(R.string.welcomeStrings.create_account_limbo_settings_button(), for: .normal)
        limboRetryButton.setTitle(R.string.appStrings.app_error_view_cta(), for: .normal)
        
        importKeyInstructionLabel.text = R.string.welcomeStrings.create_account_import_key_instruction_label()
        importKeySyncButton.setTitle(R.string.welcomeStrings.create_account_import_key_sync_button(), for: .normal)
        importKeyGoToSettings.setTitle(R.string.welcomeStrings.create_account_import_key_settings_button(), for: .normal)
        
        createBilling = BillingImpl(
            storeKitHandler: StoreKitHandler(
                billingConnectionDelegate: self,
                billingFlowDelegate: self),
            billingFlowDelegate: self)
    }

    override func intents() -> Observable<CreateAccountIntent> {
        return Observable.merge(
            Observable.just(CreateAccountIntent.start),
            self.rx.methodInvoked(#selector(CreateAccountViewController.success(skProduct:))).map { args in
                let skProduct = args[0] as! SKProduct
                return CreateAccountIntent.onSKProductSuccess(skProduct: skProduct)
            },
            Observable.merge(
                formCtaButton.rx.tap.asObservable(),
                formAccountTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
            ).map {
                CreateAccountIntent.purchaseAccount(accountName: self.formAccountTextField.text!)
            }.asObservable(),
            self.rx.methodInvoked(#selector(CreateAccountViewController.success(transactionIdentifier:))).map { args in
                CreateAccountIntent.accountPurchased(
                    transactionId: args[0] as! String,
                    accountName: self.formAccountTextField.text!)
            },
            Observable.merge(
                importKeyGoToSettings.rx.tap.asObservable(),
                limboGoToSettingsButton.rx.tap.asObservable()
            ).map {
                CreateAccountIntent.goToSettings
            },
            limboRetryButton.rx.tap.map {
                CreateAccountIntent.limboRetry
            },
            doneCtaButton.rx.tap.map {
                CreateAccountIntent.syncAccountsForPrivateKey(privateKey: self.donePrivateKeyTextView.text)
            },
            importKeySyncButton.rx.tap.map {
                CreateAccountIntent.syncAccounts
            }
        )
    }

    override func idleIntent() -> CreateAccountIntent {
        return CreateAccountIntent.idle
    }

    override func render(state: CreateAccountViewState) {
        switch state {
        case .idle:
            break
        case .startBillingConnection:
            activityIndicator.start()
            billing.startConnection()
        case .onSKProductSuccess(let formattedPrice, let skProduct):
            self.skProduct = skProduct
            activityIndicator.stop()
            formViewGroup.visible()
            formCtaButton.setTitle(R.string.welcomeStrings.create_account_cta_button(formattedPrice), for: .normal)
        case .onAccountNameValidationPassed:
            billing.pay(product: skProduct!)
        case .onCreateAccountProgress:
            formCtaActivityIndicator.start()
            formCtaButton.gone()
        case .onCreateAccountSuccess(let privateKey):
            formViewGroup.gone()
            doneViewGroup.visible()
            donePrivateKeyTextView.text = privateKey
        case .onCreateAccountFatalError:
            formCtaActivityIndicator.stop()
            formCtaButton.visible()
        case .onCreateAccountGenericError:
            formCtaActivityIndicator.stop()
            formCtaButton.visible()
            showOKDialog(message: R.string.welcomeStrings.create_account_error_generic())
        case .onCreateAccountUsernameExists:
            formCtaActivityIndicator.stop()
            formCtaButton.visible()
            showOKDialog(message: R.string.welcomeStrings.create_account_error_name_exists())
        case .onCreateAccountLimbo:
            formViewGroup.gone()
            limboViewGroup.visible()
        case .onImportKeyProgress:
            activityIndicator.start()
            doneViewGroup.gone()
            importKeyGroup.gone()
        case .onImportKeyError:
            activityIndicator.stop()
            doneViewGroup.gone()
            importKeyGroup.visible()
        case .navigateToAccounts(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.createAccountViewController.createAccountToAccount.identifier,
                model: AccountBundle(
                    accountName: accountName,
                    readOnly: false,
                    accountPage: AccountPage.balances
                )
            ))
            performSegue(withIdentifier: R.segue.createAccountViewController.createAccountToAccount, sender: self)
        case .onAccountNameValidationFailed:
            showOKDialog(message: R.string.welcomeStrings.create_account_username_length_validation_error())
        case .onAccountNameValidationNumberStartFailed:
            showOKDialog(message: R.string.welcomeStrings.create_account_username_format_validation_error())
        case .goToSettings:
            performSegue(withIdentifier: R.segue.createAccountViewController.createAccountToSettings, sender: self)
        }
    }

    override func provideViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(initialState: CreateAccountViewState.idle)
    }
    
    //
    // MARK :- BillingFlowDelegate
    //
    @objc dynamic func success(transactionIdentifier: String) {
    }
    
    func cannotMakePayment() {
        showOKDialog(message: R.string.welcomeStrings.create_account_billing_cancelled())
        formCtaActivityIndicator.stop()
        formCtaButton.visible()
    }
    
    func purchasing() {
        formCtaActivityIndicator.start()
        formCtaButton.gone()
    }
    
    func failed() {
        showOKDialog(message: R.string.welcomeStrings.create_account_billing_cancelled())
        formCtaActivityIndicator.stop()
        formCtaButton.visible()
    }
    
    func deferred() {
        print("deferred")
    }
    
    //
    // MARK :- BillingConnectionDelegate
    //
    @objc dynamic func success(skProduct: SKProduct) {
    }
    
    func skuNotFound() {
        skProductError()
    }
    
    func skuBillingUnavailable() {
        skProductError()
    }
    
    func skuRequestFailed() {
        skProductError()
    }
    
    func billingSetupFailed() {
        skProductError()
    }
    
    private func skProductError() {
        activityIndicator.stop()
        formViewGroup.gone()
        skProductNotFound.visible()
        billing.endConnection()
    }
}
