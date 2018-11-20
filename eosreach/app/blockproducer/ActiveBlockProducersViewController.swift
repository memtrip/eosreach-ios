import UIKit
import RxSwift
import RxCocoa

protocol ActiveBlockProducersDelegate {
    func onResult(blockProducerDetails: BlockProducerDetails)
}

class ActiveBlockProducersViewController
: MxViewController<ActiveBlockProducersIntent, ActiveBlockProducersResult, ActiveBlockProducersViewState, ActiveBlockProducersViewModel>, DataTableView {

    typealias tableViewType = ActiveBlockProducersTableView
    
    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var errorView: ErrorView!
    
    var delegate: ActiveBlockProducersDelegate?
    
    func dataTableView() -> tableViewType {
        return tableView as! ActiveBlockProducersTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar.title = R.string.blockProducerStrings.active_block_producer_title()
        setToolbar(toolbar: toolBar)
    }

    override func intents() -> Observable<ActiveBlockProducersIntent> {
        return Observable.merge(
            Observable.just(ActiveBlockProducersIntent.start),
            dataTableView().selected.map { blockProducerDetails in
                return ActiveBlockProducersIntent.blockProducerSelected(blockProducerDetails: blockProducerDetails)
            }
        )
    }

    override func idleIntent() -> ActiveBlockProducersIntent {
        return ActiveBlockProducersIntent.idle
    }

    override func render(state: ActiveBlockProducersViewState) {
        switch state {
        case .idle:
            break
        case .onProgress:
            activityIndicator.start()
            errorView.gone()
        case .onError:
            activityIndicator.stop()
            errorView.populate(
                title: R.string.blockProducerStrings.active_block_producer_error_title(),
                body: R.string.blockProducerStrings.active_block_producer_error_body())
        case .onSuccess(let blockProducerList):
            activityIndicator.stop()
            dataTableView().visible()
            dataTableView().populate(data: blockProducerList)
        case .blockProducerSelected(let blockProducer):
            if let delegate = self.delegate {
                delegate.onResult(blockProducerDetails: blockProducer)
                DispatchQueue.main.async {
                    self.close()
                }
            }
        case .blockProducerInformationSelected(let blockProducer):
            print("")
        }
    }

    override func provideViewModel() -> ActiveBlockProducersViewModel {
        return ActiveBlockProducersViewModel(initialState: ActiveBlockProducersViewState.idle)
    }
}
