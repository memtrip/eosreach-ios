import Foundation
import RxSwift

class DelegateBandwidthViewModel: MxViewModel<DelegateBandwidthIntent, DelegateBandwidthResult, DelegateBandwidthViewState> {
    
    override func dispatcher(intent: DelegateBandwidthIntent) -> Observable<DelegateBandwidthResult> {
        switch intent {
        case .idle:
            return just(DelegateBandwidthResult.idle)
        case.start(let manageBandwidthBundle):
            return just(DelegateBandwidthResult.populate(manageBandwidthBundle: manageBandwidthBundle))
        case.confirm(let toAccount, let netAmount, let cpuAmount, let transfer, let contractAccountBalance):
            return just(DelegateBandwidthResult.navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle(
                targetAccount: toAccount,
                netAmount: BalanceFormatter.create(
                    amount: netAmount,
                    symbol: contractAccountBalance.balance.symbol),
                cpuAmount: BalanceFormatter.create(
                    amount: cpuAmount,
                    symbol: contractAccountBalance.balance.symbol),
                transfer: transfer
            )))
        }
    }

    override func reducer(previousState: DelegateBandwidthViewState, result: DelegateBandwidthResult) -> DelegateBandwidthViewState {
        switch result {
        case .idle:
            return DelegateBandwidthViewState.idle
        case .populate(let manageBandwidthBundle):
            return DelegateBandwidthViewState.populate(manageBandwidthBundle: manageBandwidthBundle)
        case .navigateToConfirm(let bandwidthFormBundle):
            return DelegateBandwidthViewState.navigateToConfirm(bandwidthFormBundle: bandwidthFormBundle)
        }
    }
}
