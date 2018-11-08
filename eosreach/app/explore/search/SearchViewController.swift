import UIKit
import RxSwift
import RxCocoa

class SearchViewController: MxViewController<SearchIntent, SearchResult, SearchViewState, SearchViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func intents() -> Observable<SearchIntent> {
        return Observable.merge(
            Observable.just(SearchIntent.idle)
        )
    }

    override func idleIntent() -> SearchIntent {
        return SearchIntent.idle
    }

    override func render(state: SearchViewState) {
        switch state {
        case .idle:
            print("")
        }
    }

    override func provideViewModel() -> SearchViewModel {
        return SearchViewModel(initialState: SearchViewState.idle)
    }
}
