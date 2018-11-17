import Foundation
import RxSwift

class SearchViewModel: MxViewModel<SearchIntent, SearchResult, SearchViewState> {

    private let eosAccountRequest = EosAccountRequestImpl()
    
    private func searchValueChange(value: String) -> Observable<SearchResult> {
        if (value.count == 12) {
            return eosAccountRequest.getAccount(accountName: value).map { result in
                if (result.success()) {
                    let eosAccount = result.data
                    return SearchResult.onSuccess(accountCardModel: AccountCardModel(
                        accountName: eosAccount!.accountName,
                        balance: eosAccount!.balance))
                } else {
                    return SearchResult.onError
                }
            }.asObservable().startWith(SearchResult.onProgress)
        } else {
            return just(SearchResult.idle)
        }
    }

    override func dispatcher(intent: SearchIntent) -> Observable<SearchResult> {
        switch intent {
        case .idle:
            return just(SearchResult.idle)
        case .searchValueChanged(let searchValue):
            return searchValueChange(value: searchValue)
        case .viewAccount(let accountCardModel):
            return just(SearchResult.viewAccount(accountCardModel: accountCardModel))
        }
    }

    override func reducer(previousState: SearchViewState, result: SearchResult) -> SearchViewState {
        switch result {
        case .idle:
            return previousState
        case .onProgress:
            return SearchViewState.onProgress
        case .onError:
            return SearchViewState.onError
        case .onSuccess(let accountCardModel):
            return SearchViewState.onSuccess(accountCardModel: accountCardModel)
        case .viewAccount(let accountCardModel):
            return SearchViewState.viewAccount(accountCardModel: accountCardModel)
        }
    }
}
