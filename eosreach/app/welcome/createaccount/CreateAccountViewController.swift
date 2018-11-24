import UIKit
import RxSwift
import RxCocoa

class CreateAccountViewController: MxViewController<CreateAccountIntent, CreateAccountResult, CreateAccountViewState, CreateAccountViewModel> {

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var errorView: ErrorView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.welcomeStrings.create_account_title()
        formAccountTextField.placeholder = R.string.welcomeStrings.create_account_account_name_placeholder()
        formInstructionLabel.text = R.string.welcomeStrings.create_account_resource_instructions()
        formNetCpuResources.cpuValueLabel.text = R.string.welcomeStrings.create_account_resource_cpu()
        formNetCpuResources.netValueLabel.text = R.string.welcomeStrings.create_account_resource_net()
        formCtaButton.setTitle(R.string.welcomeStrings.create_account_cta_button("£2.99"), for: .normal)
        
        doneCreateAccountLabel.text = R.string.welcomeStrings.create_account_done_title()
        doneInstructionLabel.text = R.string.welcomeStrings.create_account_done_instructions()
        doneCtaButton.setTitle(R.string.welcomeStrings.create_account_done_button(), for: .normal)
    }

    override func intents() -> Observable<CreateAccountIntent> {
        return Observable.just(CreateAccountIntent.idle)
    }

    override func idleIntent() -> CreateAccountIntent {
        return CreateAccountIntent.idle
    }

    override func render(state: CreateAccountViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(initialState: CreateAccountViewState.idle)
    }
}
