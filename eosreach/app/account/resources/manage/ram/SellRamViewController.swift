import UIKit
import RxSwift
import RxCocoa

class SellRamViewController : MxViewController<SellRamIntent, SellRamResult, SellRamViewState, SellRamViewModel> {
    
    @IBOutlet weak var ramAmountTextField: ReachTextField!
    @IBOutlet weak var sellRamButton: ReachPrimaryButton!
    @IBOutlet weak var estimatedValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<SellRamIntent> {
        return Observable.merge(
            Observable.just(SellRamIntent.idle)
        )
    }

    override func idleIntent() -> SellRamIntent {
        return SellRamIntent.idle
    }

    override func render(state: SellRamViewState) {
        switch state {
        case .idle:
            break
        }
    }

    override func provideViewModel() -> SellRamViewModel {
        return SellRamViewModel(initialState: SellRamViewState.idle)
    }
}
