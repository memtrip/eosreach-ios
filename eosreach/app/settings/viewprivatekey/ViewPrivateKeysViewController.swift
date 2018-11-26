import UIKit
import RxSwift
import RxCocoa

class ViewPrivateKeysViewController: MxViewController<ViewPrivateKeysIntent, ViewPrivateKeysResult, ViewPrivateKeysViewState, ViewPrivateKeysViewModel>, DataTableView {

    typealias tableViewType = KeyPairTableView

    func dataTableView() -> KeyPairTableView {
        return tableView as! tableViewType
    }

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPrivateKeysLabel: UILabel!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var viewPrivateKeyButtonGroup: UIView!
    @IBOutlet weak var viewPrivateKeysInstructionLabel: UILabel!
    @IBOutlet weak var viewPrivateKeysButton: ReachPrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        toolBar.title = R.string.settingsStrings.settings_view_private_keys_title()
        noPrivateKeysLabel.text = R.string.settingsStrings.settings_view_private_keys_empty()
        viewPrivateKeysButton.setTitle(R.string.settingsStrings.settings_view_private_keys_button(), for: .normal)
        viewPrivateKeysInstructionLabel.text = R.string.settingsStrings.settings_view_private_keys_instruction()
    }

    override func intents() -> Observable<ViewPrivateKeysIntent> {
        return Observable.merge(
            Observable.just(ViewPrivateKeysIntent.idle),
            viewPrivateKeysButton.rx.tap.map {
                ViewPrivateKeysIntent.decryptPrivateKeys
            }
        )
    }

    override func idleIntent() -> ViewPrivateKeysIntent {
        return ViewPrivateKeysIntent.idle
    }

    override func render(state: ViewPrivateKeysViewState) {
        switch state {
        case .idle:
            break
        case .showPrivateKeys(let viewKeyPair):
            activityIndicator.stop()
            tableView.visible()
            dataTableView().populate(data: viewKeyPair)
        case .onProgress:
            activityIndicator.start()
            viewPrivateKeyButtonGroup.gone()
        case .noPrivateKeys:
            activityIndicator.stop()
            noPrivateKeysLabel.visible()
        }
    }

    override func provideViewModel() -> ViewPrivateKeysViewModel {
        return ViewPrivateKeysViewModel(initialState: ViewPrivateKeysViewState.idle)
    }
}
