import Foundation
import RxSwift

class ViewActionViewModel: MxViewModel<ViewActionIntent, ViewActionResult, ViewActionViewState> {
    
    override func dispatcher(intent: ViewActionIntent) -> Observable<ViewActionResult> {
        switch intent {
        case .idle:
            return just(ViewActionResult.idle)
        case .start(let viewActionBundle):
            return just(populate(viewActionBundle: viewActionBundle))
        case .viewTransactionBlockExplorer(let transactionId):
            return just(ViewActionResult.viewTransactionBlockExplorer(transactionId: transactionId))
        case .navigateToAccount(let accountName):
            return just(ViewActionResult.navigateToAccount(accountName: accountName))
        }
    }

    override func reducer(previousState: ViewActionViewState, result: ViewActionResult) -> ViewActionViewState {
        switch result {
        case .idle:
            return ViewActionViewState.idle
        case .populate(let accountAction, let navigationAccountName):
            return ViewActionViewState.populate(accountAction: accountAction, navigationAccountName: navigationAccountName)
        case .viewTransactionBlockExplorer(let transactionId):
            return ViewActionViewState.viewTransactionBlockExplorer(transactionId: transactionId)
        case .navigateToAccount(let accountName):
            return ViewActionViewState.navigateToAccount(accountName: accountName)
        }
    }
    
    private func populate(viewActionBundle: ViewActionBundle) -> ViewActionResult {
        if (viewActionBundle.accountAction.contractAccountBalance.accountName ==
            viewActionBundle.accountAction.to) {
            return ViewActionResult.populate(
                accountAction: viewActionBundle.accountAction,
                navigationAccountName: viewActionBundle.accountAction.from)
        } else {
            return ViewActionResult.populate(
                accountAction: viewActionBundle.accountAction,
                navigationAccountName: viewActionBundle.accountAction.to)
        }
    }
}
