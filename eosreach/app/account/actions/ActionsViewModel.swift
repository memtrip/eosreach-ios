import Foundation
import RxSwift
import eosswift

class ActionsViewModel: MxViewModel<ActionsIntent, ActionsResult, ActionsViewState> {
    
    private let accountActionsRequest = AccountActionsRequestImpl()
    
    private let ITEM_OFFSET = -500
    private let RECURSIVE_LIMIT = 10
    
    override func dispatcher(intent: ActionsIntent) -> Observable<ActionsResult> {
        switch intent {
        case .idle:
            return just(ActionsResult.idle)
        case .start(let contractAccountBalance):
            return getInitialActions(contractAccountBalance: contractAccountBalance)
                .asObservable().startWith(ActionsResult.onProgress)
        case .retry(let contractAccountBalance):
            return getInitialActions(contractAccountBalance: contractAccountBalance)
                .asObservable().startWith(ActionsResult.onProgress)
        case .loadMoreActions(let contractAccountBalance, let lastItem):
            return getMoreActions(contractAccountBalance: contractAccountBalance, lastAccountActionItem: lastItem)
                .asObservable().startWith(ActionsResult.onLoadMoreProgress)
        case .navigateToViewAction(let accountAction):
            return just(ActionsResult.navigateToViewAction(accountAction: accountAction))
        case .navigateToTransfer(let contractAccountBalance):
            return just(ActionsResult.navigateToTransfer(contractAccountBalance: contractAccountBalance))
        }
    }

    override func reducer(previousState: ActionsViewState, result: ActionsResult) -> ActionsViewState {
        switch result {
        case .idle:
            return ActionsViewState.idle
        case .onProgress:
            return ActionsViewState.onProgress
        case .onSuccess(let accountActionList):
            return ActionsViewState.onSuccess(accountActionList: accountActionList)
        case .noResults:
            return ActionsViewState.noResults
        case .onError:
            return ActionsViewState.onError
        case .onLoadMoreProgress:
            return ActionsViewState.onLoadMoreProgress
        case .onLoadMoreSuccess(let accountActionList):
            return ActionsViewState.onLoadMoreSuccess(accountActionList: accountActionList)
        case .onLoadMoreError:
            return ActionsViewState.onLoadMoreProgress
        case .navigateToViewAction(let accountAction):
            return ActionsViewState.navigateToViewAction(accountAction: accountAction)
        case .navigateToTransfer(let contractAccountBalance):
            return ActionsViewState.navigateToTransfer(contractAccountBalance: contractAccountBalance)
        }
    }
    
    private func getInitialActions(
        contractAccountBalance: ContractAccountBalance,
        position: Int = -1,
        recursivePosition: Int = 0
    ) -> Single<ActionsResult> {
        if (recursivePosition >= RECURSIVE_LIMIT) {
            return Single.just(ActionsResult.noResults)
        } else {
            return accountActionsRequest.getActionsForAccountName(
                contractAccountBalance: contractAccountBalance,
                position: position,
                offset: ITEM_OFFSET
            ).flatMap { result in
                if (result.success()) {
                    let results = result.data!
                    if (results.actions.isEmpty) {
                        if (results.noResultsNext > 0) {
                            return self.getInitialActions(
                                contractAccountBalance: contractAccountBalance,
                                position: results.noResultsNext,
                                recursivePosition: recursivePosition + 1)
                        } else {
                            return Single.just(ActionsResult.noResults)
                        }
                    } else {
                        return Single.just(ActionsResult.onSuccess(accountActionList: results))
                    }
                } else {
                    return Single.just(ActionsResult.onError)
                }
            }.catchErrorJustReturn(ActionsResult.onError)
        }
    }
    
    private func getMoreActions(
        contractAccountBalance: ContractAccountBalance,
        lastAccountActionItem: AccountAction,
        recursivePosition: Int = 0
    ) -> Single<ActionsResult> {
        if (recursivePosition >= RECURSIVE_LIMIT) {
            // end
            return Single.just(ActionsResult.onLoadMoreSuccess(accountActionList: AccountActionList(actions: [])))
        } else {
            if (lastAccountActionItem.accountActionSequence > 0) {
                return self.accountActionsRequest.getActionsForAccountName(
                    contractAccountBalance: contractAccountBalance,
                    position: lastAccountActionItem.accountActionSequence - 1,
                    offset: ITEM_OFFSET
                ).flatMap { result in
                    if (result.success()) {
                        let results = result.data!
                        if (results.actions.isEmpty) {
                            if (results.noResultsNext > 0) {
                                return self.getMoreActions(
                                    contractAccountBalance: contractAccountBalance,
                                    lastAccountActionItem: lastAccountActionItem,
                                    recursivePosition: recursivePosition + 1
                                )
                            } else {
                                return Single.just(ActionsResult.onLoadMoreSuccess(accountActionList: results))
                            }
                        } else {
                            // end
                            return Single.just(ActionsResult.onLoadMoreSuccess(accountActionList: AccountActionList(actions: [])))
                        }
                    } else {
                        return Single.just(ActionsResult.onLoadMoreError)
                    }
                }
            } else {
                // end
                return Single.just(ActionsResult.onLoadMoreSuccess(accountActionList: AccountActionList(actions: [])))
            }
        }
    }
}
