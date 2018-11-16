import UIKit
import RxSwift
import RxCocoa

class SearchViewController: MxViewController<SearchIntent, SearchResult, SearchViewState, SearchViewModel> {

    @IBOutlet weak var searchTextField: ReachTextField!
    @IBOutlet weak var searchResultContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.placeholder = R.string.exploreStrings.explore_search_textfield_placeholder()
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
        case .onProgress:
            print("")
        case .onError:
            print("")
        case .onSuccess(let accountEntity):
            print("")
        case .viewAccount(let accountEntity):
            print("")
        }
    }

    override func provideViewModel() -> SearchViewModel {
        return SearchViewModel(initialState: SearchViewState.idle)
    }
}
