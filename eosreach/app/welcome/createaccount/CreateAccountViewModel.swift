import Foundation
import RxSwift

class CreateAccountViewModel: MxViewModel<CreateAccountIntent, CreateAccountResult, CreateAccountViewState> {

    override func dispatcher(intent: CreateAccountIntent) -> Observable<CreateAccountResult> {
        switch intent {
        case .idle:
            return just(CreateAccountResult.idle)
        }
    }

    override func reducer(previousState: CreateAccountViewState, result: CreateAccountResult) -> CreateAccountViewState {
        switch result {
        case .idle:
            return CreateAccountViewState.idle
        }
    }
}
