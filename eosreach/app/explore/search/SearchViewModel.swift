import Foundation
import RxSwift

class SearchViewModel: MxViewModel<SearchIntent, SearchResult, SearchViewState> {

    override func dispatcher(intent: SearchIntent) -> Observable<SearchResult> {
        switch intent {
        case .idle:
            return just(SearchResult.idle)
        }
    }

    override func reducer(previousState: SearchViewState, result: SearchResult) -> SearchViewState {
        switch result {
        case .idle:
            return previousState
        }
    }
}
