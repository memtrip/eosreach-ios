import Foundation
import RxSwift

class BalanceViewModel: MxViewModel<BalanceIntent, BalanceResult, BalanceViewState> {

    override func dispatcher(intent: BalanceIntent) -> Observable<BalanceResult> {
        switch intent {
        case .idle:
            fatalError()
        case .start(let accountBalances):
            fatalError()
        case .scanForAirdropTokens(let accountName):
            fatalError()
        case .navigateToCreateAccount:
            fatalError()
        case .navigateToActions(let balance):
            fatalError()
        }
    }

    override func reducer(previousState: BalanceViewState, result: BalanceResult) -> BalanceViewState {
        switch result {
        case .idle:
            fatalError()
        case .populate(let accountBalances):
            fatalError()
        case .onAirdropError(let message):
            fatalError()
        case .onAirdropSuccess:
            fatalError()
        case .onAirdropProgress:
            fatalError()
        case .navigateToCreateAccount:
            fatalError()
        case .navigateToActions(let contractAccountBalance):
            fatalError()
        }
    }
}
