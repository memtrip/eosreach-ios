import Foundation
import RxSwift

class SplashViewModel: MxViewModel<SplashIntent, SplashResult, SplashViewState> {

    override func dispatcher(intent: SplashIntent) -> Observable<SplashResult> {
        switch intent {
        case .idle:
            return just(SplashResult.idle)
        case .navigateToCreateAccount:
            return just(SplashResult.navigateToCreateAccount)
        case .navigateToImportPrivateKey:
            return just(SplashResult.navigateToImportPrivateKey)
        case .navigateToExplore:
            return just(SplashResult.navigateToExplore)
        }
    }

    override func reducer(previousState: SplashViewState, result: SplashResult) -> SplashViewState {
        switch result {
        case .idle:
            return SplashViewState.idle
        case .navigateToCreateAccount:
            return SplashViewState.navigateToCreateAccount
        case .navigateToImportPrivateKey:
            return SplashViewState.navigateToImportPrivateKey
        case .navigateToExplore:
            return SplashViewState.navigateToExplore
        }
    }
}
