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
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!

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
        currentEndpointUrl.text = state.endpointUrl
        switch state.view {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            changeEndpointButton.gone()
        case .onSuccess:
            activityIndicator.stop()
            changeEndpointButton.visible()
            showOKDialog(
                title: R.string.settingsStrings.settings_eos_endpoint_success_title(),
                message: R.string.settingsStrings.settings_eos_endpoint_success_body())
        case .navigateToBlockProducerList:
            print("")
        case .onErrorInvalidUrl:
            activityIndicator.stop()
            changeEndpointButton.visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.settingsStrings.settings_eos_endpoint_error_invalid_url())
        case .onErrorNothingChanged:
            activityIndicator.stop()
            changeEndpointButton.visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.settingsStrings.settings_eos_endpoint_error_nothing_changed(state.endpointUrl))
        case .onErrorGeneric:
            activityIndicator.stop()
            changeEndpointButton.visible()
            showOKDialog(
                title: R.string.appStrings.app_error_view_title(),
                message: R.string.settingsStrings.settings_eos_endpoint_generic())
        }
    }

    override func provideViewModel() -> EosEndpointViewModel {
        return EosEndpointViewModel(initialState: EosEndpointViewState(
            endpointUrl: EosEndpoint().get(),
            view: EosEndpointViewState.View.idle
        ))
    }
}
