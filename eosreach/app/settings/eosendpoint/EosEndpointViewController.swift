import UIKit
import RxSwift
import RxCocoa

class EosEndpointViewController: MxViewController<EosEndpointIntent, EosEndpointResult, EosEndpointViewState, EosEndpointViewModel> {

    @IBOutlet weak var toolbar: ReachToolbar!
    @IBOutlet weak var currentEndpointLabel: UILabel!
    @IBOutlet weak var currentEndpointUrl: UILabel!
    @IBOutlet weak var changeEndpointTextField: ReachTextField!
    @IBOutlet weak var chooseBlockProducerButton: ReachButton!
    @IBOutlet weak var changeEndpointButton: ReachPrimaryButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.title = R.string.settingsStrings.settings_eos_endpoint_title()
        currentEndpointLabel.text = R.string.settingsStrings.settings_eos_endpoint_current_label()
        changeEndpointTextField.placeholder = R.string.settingsStrings.settings_eos_endpoint_placeholder()
        chooseBlockProducerButton.setTitle(R.string.settingsStrings.settings_eos_endpoint_block_producer_button(), for: .normal)
        changeEndpointButton.setTitle(R.string.settingsStrings.settings_eos_endpoint_cta_button(), for: .normal)
        setToolbar(toolbar: toolbar)
    }

    override func intents() -> Observable<EosEndpointIntent> {
        return Observable.merge(
            Observable.just(EosEndpointIntent.idle),
            changeEndpointButton.rx.tap.map {
                EosEndpointIntent.navigateToBlockProducerList
            },
            changeEndpointButton.rx.tap.map {
                EosEndpointIntent.changeEndpoint(endpoint: self.changeEndpointTextField.text!)
            }
        )
    }

    override func idleIntent() -> EosEndpointIntent {
        return EosEndpointIntent.idle
    }

    override func render(state: EosEndpointViewState) {
        switch state {
        case .idle:
            print("")
        case .onProgress:
            print("")
        case .onError(let message):
            print("")
        case .onSuccess:
            print("")
        case .navigateToBlockProducerList:
            print("")
        }
    }

    override func provideViewModel() -> EosEndpointViewModel {
        return EosEndpointViewModel(initialState: EosEndpointViewState.idle)
    }
}
