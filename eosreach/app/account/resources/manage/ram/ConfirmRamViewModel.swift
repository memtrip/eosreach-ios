import Foundation
import RxSwift
import eosswift

class ConfirmRamViewModel: MxViewModel<ConfirmRamIntent, ConfirmRamResult, ConfirmRamViewState> {
    
    private let ramRequest = RamRequestImpl()
    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerImpl()
    
    override func dispatcher(intent: ConfirmRamIntent) -> Observable<ConfirmRamResult> {
        switch intent {
        case .idle:
            return just(ConfirmRamResult.idle)
        case .start(let ramBundle):
            return just(ConfirmRamResult.populate(commitType: ramBundle.commitType))
        case .confirm(let accountName, let kb, let commitType):
            return confirm(
                account: accountName,
                kb: kb,
                commitType: commitType)
        }
    }

    override func reducer(previousState: ConfirmRamViewState, result: ConfirmRamResult) -> ConfirmRamViewState {
        switch result {
        case .idle:
            return ConfirmRamViewState.idle
        case .populate(let commitType):
            return ConfirmRamViewState.populate(commitType: commitType)
        case .onProgress:
            return ConfirmRamViewState.onProgress
        case .onSuccess(let actionReceipt):
            return ConfirmRamViewState.onSuccess(actionReceipt: actionReceipt)
        case .genericError:
            return ConfirmRamViewState.genericError
        case .errorWithLog(let log):
            return ConfirmRamViewState.errorWithLog(log: log)
        }
    }
    
    private func confirm(
        account: String,
        kb: String,
        commitType: RamBundle.CommitType
    ) -> Observable<ConfirmRamResult> {
        return getAccountByName.select(accountName: account).flatMap { accountEntity in
            return self.eosKeyManager.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                switch commitType {
                case .buy:
                    return self.buyRam(account: account, quantity: Double(kb)!, privaeKey: privateKey)
                case .sell:
                    return self.sellRam(account: account, quantity: Double(kb)!, privaeKey: privateKey)
                }
            }.catchErrorJustReturn(ConfirmRamResult.genericError)
        }.catchErrorJustReturn(ConfirmRamResult.genericError)
            .asObservable()
            .startWith(ConfirmRamResult.onProgress)
    }
    
    private func buyRam(
        account: String,
        quantity: Double,
        privaeKey: EOSPrivateKey
    ) -> Single<ConfirmRamResult> {
        return ramRequest.buy(receiver: account, kb: quantity, authorizingPrivateKey: privaeKey).map { result in
            if (result.success()) {
                return ConfirmRamResult.onSuccess(actionReceipt: result.data!)
            } else {
                return self.ramError(ramError: result.error!)
            }
        }.catchErrorJustReturn(ConfirmRamResult.genericError)
    }
    
    private func sellRam(
        account: String,
        quantity: Double,
        privaeKey: EOSPrivateKey
    ) -> Single<ConfirmRamResult> {
        return ramRequest.sell(account: account, kb: quantity, authorizingPrivateKey: privaeKey).map { result in
            if (result.success()) {
                return ConfirmRamResult.onSuccess(actionReceipt: result.data!)
            } else {
                return self.ramError(ramError: result.error!)
            }
        }.catchErrorJustReturn(ConfirmRamResult.genericError)
    }
    
    private func ramError(ramError: RamError) -> ConfirmRamResult {
        switch ramError {
        case .genericError:
            return ConfirmRamResult.genericError
        case .withLog(let body):
            return ConfirmRamResult.errorWithLog(log: body)
        }
    }
}
