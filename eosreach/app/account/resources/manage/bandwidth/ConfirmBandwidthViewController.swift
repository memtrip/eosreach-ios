import UIKit
import RxSwift
import RxCocoa

class ConfirmBandwidthViewController
: MxViewController<ConfirmBandwidthIntent, ConfirmBandwidthResult, ConfirmBandwidthViewState, ConfirmBandwidthViewModel> {
    
    var bandwidthFormBundle: BandwidthFormBundle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<ConfirmBandwidthIntent> {
        return Observable.merge(
            Observable.just(ConfirmBandwidthIntent.idle)
        )
    }

    override func idleIntent() -> ConfirmBandwidthIntent {
        return ConfirmBandwidthIntent.idle
    }

    override func render(state: ConfirmBandwidthViewState) {
        switch state {
        case .idle:
            break
        case .populate(let manageBandwidthBundle):
            print("")
        case .onProgress:
            print("")
        case .onError:
            print("")
        case .withLog(let log):
            print("")
        case .navigateToTransactionConfirmed(let transactionId):
            print("")
        }
    }

    override func provideViewModel() -> ConfirmBandwidthViewModel {
        return ConfirmBandwidthViewModel(initialState: ConfirmBandwidthViewState.idle)
    }
}
