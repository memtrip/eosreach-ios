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
    @IBOutlet weak var donePrivateKey: UITextField!
    @IBOutlet weak var doneCtaButton: ReachPrimaryButton!
    @IBOutlet weak var doneCtaActivityIndicator: UIActivityIndicatorView!
    
    private let billing = BillingImpl(storeKitHandler: StoreKitHandler())
    private var skProduct: SKProduct?
    
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
    }

    override func intents() -> Observable<CreateAccountIntent> {
        return Observable.merge(
            Observable.just(CreateAccountIntent.startBillingConnection),
            self.rx.methodInvoked(#selector(CreateAccountViewController.success(skProduct:))).map { args in
                let skProduct = args[0] as! SKProduct
                return CreateAccountIntent.onSKProductSuccess(skProduct: skProduct)
            },
            Observable.merge(
                formAccountTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
                formCtaButton.rx.tap.asObservable()
            ).map {
                CreateAccountIntent.createAccount(accountName: self.formAccountTextField.text!)
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
            billing.startConnection(billingConnectionDelegate: self, billingFlowDelegate: self)
        case .onSKProductSuccess(let formattedPrice, let skProduct):
            self.skProduct = skProduct
            activityIndicator.stop()
            formViewGroup.visible()
            formCtaButton.setTitle(R.string.welcomeStrings.create_account_cta_button(formattedPrice), for: .normal)
        case .onAccountNameValidationPassed:
            billing.pay(product: skProduct!)
        case .onCreateAccountProgress:
            print("")
        case .onCreateAccountSuccess(let transactionIdentifier):
            print("")
        case .onImportKeyProgress:
            print("")
        case .onImportKeyError:
            print("")
        case .navigateToAccounts:
            print("")
        case .onAccountNameValidationFailed:
            showOKDialog(message: R.string.welcomeStrings.create_account_username_format_validation_error())
        case .onAccountNameValidationNumberStartFailed:
            showOKDialog(message: R.string.welcomeStrings.create_account_username_length_validation_error())
        }
    }

    override func provideViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(initialState: CreateAccountViewState.idle)
    }
    
    //
    // MARK :- BillingFlowDelegate
    //
    func cannotMakePayment() {
        print("cannotMakePayment")
    }
    
    func purchasing() {
        print("purchasing")
    }
    
    func success(transactionIdentifier: String) {
        print("success")
    }
    
    func failed() {
        print("failed")
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
        activityIndicator.stop()
        formViewGroup.gone()
        skProductNotFound.visible()
        billing.endConnection()
    }
    
    func skuBillingUnavailable() {
        print("skuBillingUnavailable")
    }
    
    func skuRequestFailed() {
        print("skuRequestFailed")
    }
    
    func billingSetupFailed() {
        print("billingSetupFailed")
    }
}
