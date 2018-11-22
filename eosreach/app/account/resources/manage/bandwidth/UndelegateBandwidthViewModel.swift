import Foundation
import RxSwift

class UndelegateBandwidthViewModel: MxViewModel<UndelegateBandwidthIntent, UndelegateBandwidthResult, UndelegateBandwidthViewState> {
    
    override func dispatcher(intent: UndelegateBandwidthIntent) -> Observable<UndelegateBandwidthResult> {
        switch intent {
        case .idle:
            return just(UndelegateBandwidthResult.idle)
        case.start(let manageBandwidthBundle, let prepopulated):
            return just(populate(manageBandwidthBundle: manageBandwidthBundle, prepopulated: prepopulated))
        case.confirm(let toAccount, let netAmount, let cpuAmount, let contractAccountBalance):
            return just(UndelegateBandwidthResult.navigateToConfirm(bandwidthFormBundle: BandwidthFormBundle(
                targetAccount: toAccount,
                netAmount: BalanceFormatter.create(
                    amount: netAmount,
                    symbol: contractAccountBalance.balance.symbol),
                cpuAmount: BalanceFormatter.create(
                    amount: cpuAmount,
                    symbol: contractAccountBalance.balance.symbol),
                transfer: false,
                contractAccountBalance: contractAccountBalance,
                type: BandwidthFormBundle.CommitType.undelegate
            )))
        }
    }

    override func reducer(previousState: UndelegateBandwidthViewState, result: UndelegateBandwidthResult) -> UndelegateBandwidthViewState {
        switch result {
        case .idle:
            return UndelegateBandwidthViewState.idle
        case .populate(let manageBandwidthBundle):
            return UndelegateBandwidthViewState.populate(manageBandwidthBundle: manageBandwidthBundle)
        case .prepopulate(let manageBandwidthBundle, let prepopulated):
            return UndelegateBandwidthViewState.prepopulate(manageBandwidthBundle: manageBandwidthBundle, prepopulated: prepopulated)
        case .navigateToConfirm(let bandwidthFormBundle):
            return UndelegateBandwidthViewState.navigateToConfirm(bandwidthFormBundle: bandwidthFormBundle)
        }
    }
    
    private func populate(manageBandwidthBundle: ManageBandwidthBundle, prepopulated: DelegatedBandwidth?) -> UndelegateBandwidthResult {
        if let prepopulated = prepopulated {
            return UndelegateBandwidthResult.prepopulate(manageBandwidthBundle: manageBandwidthBundle, prepopulated: prepopulated)
        } else {
            return UndelegateBandwidthResult.populate(manageBandwidthBundle: manageBandwidthBundle)
        }
    }
}
