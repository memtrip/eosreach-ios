import UIKit
import RxSwift
import RxCocoa

class TransferViewController : MxViewController<TransferIntent, TransferResult, TransferViewState, TransferViewModel> {
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var toTextField: ReachTextField!
    @IBOutlet weak var amountTextField: ReachTextField!
    @IBOutlet weak var memoTextField: ReachTextField!
    @IBOutlet weak var nextButton: ReachPrimaryButton!
    
    private lazy var transferBundle = {
        return self.getDestinationBundle()!.model as! TransferBundle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.transferStrings.transfer_form_title()
        toTextField.placeholder = R.string.transferStrings.transfer_form_to_placeholder()
        amountTextField.placeholder = R.string.transferStrings.transfer_form_amount_placeholder("-")
        memoTextField.placeholder = R.string.transferStrings.transfer_form_memo_placeholder()
        nextButton.setTitle(R.string.transferStrings.transfer_form_next_button(), for: .normal)
        let _ = toTextField.becomeFirstResponder()
    }

    override func intents() -> Observable<TransferIntent> {
        return Observable.merge(
            Observable.just(TransferIntent.start(contractAccountBalance: transferBundle.contractAccountBalance)),
            toTextField.rx.controlEvent(.editingDidEndOnExit).map {
                return TransferIntent.moveToBalanceField
            },
            Observable.merge(
                memoTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(),
                nextButton.rx.tap.asObservable()
            ).map {
                TransferIntent.submitForm(
                    toAccountName: self.toTextField.text!,
                    amount: self.amountTextField.text!,
                    memo: self.memoTextField.text!,
                    contractAccountBalance: self.transferBundle.contractAccountBalance)
            }
        )
    }

    override func idleIntent() -> TransferIntent {
        return TransferIntent.idle
    }

    override func render(state: TransferViewState) {
        switch state {
        case .idle:
            break
        case .populate(let availableBalance):
            amountTextField.placeholder = R.string.transferStrings.transfer_form_amount_placeholder(availableBalance)
        case .moveToBalanceField:
            let _ = amountTextField.becomeFirstResponder()
        case .navigateToConfirm(let transferFormBundle):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.transferViewController.transferToTransferConfirmation.identifier,
                model: transferFormBundle))
            performSegue(withIdentifier: R.segue.transferViewController.transferToTransferConfirmation, sender: self)
        case .validationError(let message):
            showOKDialog(message: message)
        }
    }

    override func provideViewModel() -> TransferViewModel {
        return TransferViewModel(initialState: TransferViewState.idle)
    }
}
