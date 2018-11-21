import UIKit
import RxSwift
import RxCocoa

class VoteViewController: MxViewController<VoteIntent, VoteResult, VoteViewState, VoteViewModel> {

    @IBOutlet weak var castVoteTitleLabel: UILabel!
    @IBOutlet weak var producerButton: ReachButton!
    @IBOutlet weak var proxyButton: ReachButton!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var producersTableView: UITableView!
    @IBOutlet weak var proxyTableView: UITableView!
    @IBOutlet weak var voteTopConstraint: NSLayoutConstraint!
    
    func voteProducerTableView() -> VoteProducerTableView {
        return producersTableView as! VoteProducerTableView
    }
    
    func voteProxyTableView() -> VoteProducerTableView {
        return proxyTableView as! VoteProducerTableView
    }
    
    var eosAccountVote: EosAccountVote?
    var readOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castVoteTitleLabel.text = R.string.voteStrings.vote_cast_vote_title()
        producerButton.setTitle(R.string.voteStrings.vote_producer_button(), for: .normal)
        proxyButton.setTitle(R.string.voteStrings.vote_proxy_button(), for: .normal)
        
        if (readOnly) {
            castVoteTitleLabel.goneCollapsed()
            producerButton.goneCollapsed()
            proxyButton.goneCollapsed()
            voteTopConstraint.constant = 0
        }
    }

    override func intents() -> Observable<VoteIntent> {
        return Observable.merge(
            Observable.just(VoteIntent.start(eosAccountVote: eosAccountVote)),
            producerButton.rx.tap.map {
                return VoteIntent.navigateToCastProducerVote
            },
            proxyButton.rx.tap.map {
                return VoteIntent.navigateToCastProxyVote
            },
            voteProxyTableView().selected.map { proxyAccountName in
                return VoteIntent.navigateToViewProxy(accountName: proxyAccountName)
            },
            voteProducerTableView().selected.map { producerAccountName in
                return VoteIntent.navigateToViewProducer(accountName: producerAccountName)
            }
        )
    }

    override func idleIntent() -> VoteIntent {
        return VoteIntent.idle
    }

    override func render(state: VoteViewState) {
        switch state {
        case .idle:
            break
        case .populateProxyVote(let proxyAccountName):
            voteProxyTableView().visible()
            voteProxyTableView().populate(data: [proxyAccountName])
            voteLabel.text = R.string.voteStrings.vote_proxy_title()
        case .populateProducerVotes(let eosAccountVote):
            voteProducerTableView().visible()
            voteProducerTableView().populate(data: eosAccountVote.producers)
            voteLabel.text = R.string.voteStrings.vote_producer_title()
        case .noVoteCast:
            if (readOnly) {
                voteLabel.text = R.string.voteStrings.vote_read_only_no_vote()
            } else {
                fatalError("not implemented")
            }
        case .navigateToCastProducerVote:
            performSegue(withIdentifier: R.segue.voteViewController.voteToCastProducer, sender: self)
        case .navigateToCastProxyVote:
            performSegue(withIdentifier: R.segue.voteViewController.voteToCastProxy, sender: self)
        case .navigateToViewProducer(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.voteViewController.voteToViewBlockProducerDetails.identifier,
                model: ViewBlockProducerBundle(accountName: accountName, blockProducerDetails: nil)
            ))
            performSegue(withIdentifier: R.segue.voteViewController.voteToViewBlockProducerDetails, sender: self)
        case .navigateToViewProxyVote(let accountName):
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.voteViewController.voteToViewProxyVoterDetails.identifier,
                model: ViewProxyVoterBundle(accountName: accountName, proxyVoterDetails: nil)
            ))
            performSegue(withIdentifier: R.segue.voteViewController.voteToViewProxyVoterDetails, sender: self)
        case .onVoteForUsProgress:
            print("")
        case .onVoteForUsSuccess:
            print("")
        case .onVoteForUsError(let log):
            print("")
        case .onVoteForUsGenericError:
            print("")
        }
    }

    override func provideViewModel() -> VoteViewModel {
        return VoteViewModel(initialState: VoteViewState.idle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == R.segue.voteViewController.voteToCastProducer.identifier) {
            (segue.destination as! CastViewController).castBundle = CastBundle(castTab: CastTab.producers)
        } else {
            (segue.destination as! CastViewController).castBundle = CastBundle(castTab: CastTab.proxy)
        }
    }
}
