import Foundation
import RxSwift

class SellRamViewModel: MxViewModel<SellRamIntent, SellRamResult, SellRamViewState> {
    
    override func dispatcher(intent: SellRamIntent) -> Observable<SellRamResult> {
        switch intent {
        case .idle:
            return just(SellRamResult.idle)
        case .convertKiloBytesToEOSCost(let kb, let costPerKb):
            return just(calculateCost(kb: kb, costPerKb: costPerKb))
        case .commit(let kb):
            return just(commit(kb: kb))
        }
    }

    override func reducer(previousState: SellRamViewState, result: SellRamResult) -> SellRamViewState {
        switch result {
        case .idle:
            return SellRamViewState.idle
        case .navigateToConfirmRamForm(let kilobytes):
            return SellRamViewState.navigateToConfirmRamForm(kilobytes: kilobytes)
        case .updateCostPerKiloByte(let eosCost):
            return SellRamViewState.updateCostPerKiloByte(eosCost: eosCost)
        case .emptyRamError:
            return SellRamViewState.emptyRamError
        }
    }
    
    private func commit(kb: String) -> SellRamResult {
        let kbValue: Double = (kb.isEmpty || kb == ".") ? 0.0 : Double(kb)!
        if (kbValue == 0.0) {
            return SellRamResult.emptyRamError
        } else {
            return SellRamResult.navigateToConfirmRamForm(kilobytes: kb)
        }
    }
    
    private func calculateCost(kb: String, costPerKb: Balance) -> SellRamResult {
        let kbValue: Double = (kb.isEmpty || kb == ".") ? 0.0 : Double(kb)!
        let eosCost = kbValue * costPerKb.amount
        return SellRamResult.updateCostPerKiloByte(eosCost:
            BalanceFormatter.formatEosBalance(amount: eosCost, symbol: costPerKb.symbol))
    }
}
