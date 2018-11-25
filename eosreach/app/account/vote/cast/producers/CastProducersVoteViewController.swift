import UIKit
import RxSwift
import RxCocoa

class CastProducersVoteViewController: MxViewController<CastProducersVoteIntent, CastProducersVoteResult, CastProducersVoteViewState, CastProducersVoteViewModel>, DataTableView, ActiveBlockProducersDelegate {

    typealias tableViewType = CastProducersVoteTableView

    func dataTableView() -> CastProducersVoteTableView {
        return tableView as! tableViewType
    }
    
    @IBOutlet weak var voteButton: ReachButton!
    @IBOutlet weak var activityIndicator: ReachActivityIndicator!
    @IBOutlet weak var addFromListButton: ReachButton!
    @IBOutlet weak var addButton: ReachButton!
    @IBOutlet weak var producersInstruction: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var eosAccount: EosAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFromListButton.setTitle(R.string.voteStrings.cast_producers_add_from_list_button(), for: .normal)
        addButton.setTitle(R.string.voteStrings.cast_producers_add_button(), for: .normal)
        producersInstruction.text = R.string.voteStrings.cast_producers_instructions_label()
        voteButton.setTitle(R.string.voteStrings.cast_producers_vote_button(), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func intents() -> Observable<CastProducersVoteIntent> {
        return Observable.merge(
            Observable.just(CastProducersVoteIntent.start(eosAccountVote: eosAccount!.eosAcconuntVote)),
            addButton.rx.tap.map {
                CastProducersVoteIntent.idle
            },
            addFromListButton.rx.tap.map {
                CastProducersVoteIntent.addProducerFromList
            },
            addButton.rx.tap.map {
                CastProducersVoteIntent.addProducerField
            },
            voteButton.rx.tap.map {
                CastProducersVoteIntent.vote(
                    voterAccountName: self.eosAccount!.accountName,
                    blockProducers: self.dataTableView().data)
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
        case .onProgress:
            activityIndicator.start()
            voteButton.gone()
        case .addProducerFromList:
            performSegue(withIdentifier: R.segue.castProducersVoteViewController.castProducerVoteToActiveBlockProducerList, sender: self)
        case .addExistingProducers(let producers):
            dataTableView().populate(data: producers)
        case .addProducerField:
            dataTableView().addProducer(producer: "")
        case .onGenericError:
            activityIndicator.stop()
            voteButton.visible()
        case .onSuccess:
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.castProducersVoteViewController.castProducersVoteToAccount.identifier,
                model: AccountBundle(
                    accountName: eosAccount!.accountName,
                    readOnly: false,
                    accountPage: AccountPage.vote
                )
            ))
            performSegue(withIdentifier: R.segue.castProducersVoteViewController.castProducersVoteToAccount, sender: self)
        case .viewLog(let log):
            showViewLog(viewLogHandler: { (_) in
                self.activityIndicator.stop()
                self.voteButton.visible()
                self.showTransactionLog(log: log)
            })
        }
    }

    override func provideViewModel() -> CastProducersVoteViewModel {
        return CastProducersVoteViewModel(initialState: CastProducersVoteViewState.idle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == R.segue.castProducersVoteViewController.castProducerVoteToActiveBlockProducerList.identifier) {
            (segue.destination as! ActiveBlockProducersViewController).delegate = self
        }
    }
    
    //
    // MARK :- ActiveBlockProducersDelegate
    //
    func selected(blockProducerDetails: BlockProducerDetails) {
        dataTableView().addProducer(producer: blockProducerDetails.owner)
    }
    
    //
    // MARK :- keyboard visibility
    //
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.tableViewBottomConstraint.constant == 0 {
                self.tableViewBottomConstraint.constant += keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant = 0
    }
}
