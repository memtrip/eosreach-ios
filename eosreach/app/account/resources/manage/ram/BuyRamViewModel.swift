import Foundation
import RxSwift

class BuyRamViewModel: MxViewModel<BuyRamIntent, BuyRamResult, BuyRamViewState> {
    
    override func dispatcher(intent: BuyRamIntent) -> Observable<BuyRamResult> {
        switch intent {
        case .idle:
            return just(BuyRamResult.idle)
        case .convertKiloBytesToEOSCost(let kb, let costPerKb):
            return just(calculateCost(kb: kb, costPerKb: costPerKb))
        case .commit(let kb):
            return just(commit(kb: kb))
        }
    }

    override func reducer(previousState: BuyRamViewState, result: BuyRamResult) -> BuyRamViewState {
        switch result {
        case .idle:
            return BuyRamViewState.idle
        case .navigateToConfirmRamForm(let kilobytes):
            return BuyRamViewState.navigateToConfirmRamForm(kilobytes: kilobytes)
        case .updateCostPerKiloByte(let eosCost):
            return BuyRamViewState.updateCostPerKiloByte(eosCost: eosCost)
        case .emptyRamError:
            return BuyRamViewState.emptyRamError
        }
    }
    
    private func commit(kb: String) -> BuyRamResult {
        let kbValue: Double = (kb.isEmpty || kb == ".") ? 0.0 : Double(kb)!
        if (kbValue == 0.0) {
            return BuyRamResult.emptyRamError
        } else {
            return BuyRamResult.navigateToConfirmRamForm(kilobytes: kb)
        }
    }
    
    private func calculateCost(kb: String, costPerKb: Balance) -> BuyRamResult {
        let kbValue: Double = (kb.isEmpty || kb == ".") ? 0.0 : Double(kb)!
        let eosCost = kbValue * costPerKb.amount
        return BuyRamResult.updateCostPerKiloByte(eosCost:
            BalanceFormatter.formatEosBalance(amount: eosCost, symbol: costPerKb.symbol))
    }
}
