import Foundation
import RxSwift

class ManageRamViewModel: MxViewModel<ManageRamIntent, ManageRamResult, ManageRamViewState> {
    
    private let ramPriceRequest = RamPriceRequestImpl()
    
    override func dispatcher(intent: ManageRamIntent) -> Observable<ManageRamResult> {
        switch intent {
        case .idle:
            return just(ManageRamResult.idle)
        case .start(let symbol):
            return getRamPrice(symbol: symbol)
        }
    }

    override func reducer(previousState: ManageRamViewState, result: ManageRamResult) -> ManageRamViewState {
        switch result {
        case .idle:
            return ManageRamViewState.idle
        case .onProgress:
            return ManageRamViewState.onProgress
        case .onRamPriceError:
            return ManageRamViewState.onRamPriceError
        case .populate(let ramPricePerKb):
            return ManageRamViewState.populate(ramPricePerKb: ramPricePerKb)
        }
    }
    
    private func getRamPrice(symbol: String) -> Observable<ManageRamResult> {
        return ramPriceRequest.getRamPrice(symbol: symbol).map { ramPrice in
            if (ramPrice.success()) {
                return ManageRamResult.populate(ramPricePerKb: ramPrice.data!)
            } else {
                return ManageRamResult.onRamPriceError
            }
        }.catchErrorJustReturn(ManageRamResult.onRamPriceError)
            .asObservable()
            .startWith(ManageRamResult.onProgress)
    }
}
