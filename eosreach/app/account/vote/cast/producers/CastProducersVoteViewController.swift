import UIKit
import RxSwift
import RxCocoa

class CastProducersVoteViewController: MxViewController<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState, CastProducersVoteViewModel>, DataTableView {

    typealias tableViewType = CastProducerVoteTableView

    func dataTableView() -> CastProducerVoteTableView {
        return tableView as! tableViewType
    }
    
    @IBOutlet weak var voteButton: ReachButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var addFromListButton: ReachButton!
    @IBOutlet weak var addButton: ReachButton!
    @IBOutlet weak var producersInstruction: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFromListButton.setTitle(R.string.voteStrings.cast_producers_add_from_list_button(), for: .normal)
        addButton.setTitle(R.string.voteStrings.cast_producers_add_button(), for: .normal)
        producersInstruction.text = R.string.voteStrings.cast_producers_instructions_label()
        voteButton.setTitle(R.string.voteStrings.cast_producers_vote_button(), for: .normal)
        dataTableView().populate(data: ["memtripissue"])
    }

    override func intents() -> Observable<CastProducersVoteIntent> {
        return Observable.merge(
            Observable.just(CastProducersVoteIntent.idle),
            addButton.rx.tap.map {
                return CastProducersVoteIntent.idle
            },
            addFromListButton.rx.tap.map {
                return CastProducersVoteIntent.idle
            }
        )
    }

    override func idleIntent() -> CastProducersVoteIntent {
        return CastProducersVoteIntent.idle
    }

    override func render(state: CastProducersVoteViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> CastProducersVoteViewModel {
        return CastProducersVoteViewModel(initialState: CastProducersVoteViewState.idle)
    }
}
