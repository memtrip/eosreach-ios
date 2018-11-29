import Foundation
import RxSwift
import eosswift

class TransferConfirmViewModel: MxViewModel<TransferConfirmIntent, TransferConfirmResult, TransferConfirmViewState> {

    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerImpl()
    private let transferRequest = TransferRequestImpl()
    private let insertTransactionLog = InsertTransactionLog()
    
    override func dispatcher(intent: TransferConfirmIntent) -> Observable<TransferConfirmResult> {
        switch intent {
        case .idle:
            return just(TransferConfirmResult.idle)
        case .start(let transferFormBundle):
            return just(TransferConfirmResult.populate(transferFormBundle: transferFormBundle))
        case .transfer(let transferFormBundle):
            return transfer(
                contract: transferFormBundle.contractAccountBalance.contractName,
                fromAccount: transferFormBundle.contractAccountBalance.accountName,
                toAccount: transferFormBundle.toAccountName,
                quantity: transferFormBundle.amount,
                memo: transferFormBundle.memo)
        }
    }

    override func reducer(previousState: TransferConfirmViewState, result: TransferConfirmResult) -> TransferConfirmViewState {
        switch result {
        case .idle:
            return TransferConfirmViewState.idle
        case .populate(let transferFormBundle):
            return TransferConfirmViewState.populate(transferFormBundle: transferFormBundle)
        case .onProgress:
            return TransferConfirmViewState.onProgress
        case .onSuccess(let actionReceipt):
            return TransferConfirmViewState.onSuccess(actionReceipt: actionReceipt)
        case .onError:
            return TransferConfirmViewState.onError
        case .errorWithLog(let log):
            return TransferConfirmViewState.errorWithLog(log: log)
        }
    }
    
    func transfer(
        contract: String,
        fromAccount: String,
        toAccount: String,
        quantity: String,
        memo: String
    ) -> Observable<TransferConfirmResult> {
        return getAccountByName.select(accountName: fromAccount).flatMap { accountEntity in
            return self.eosKeyManager.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                return self.transferRequest.transfer(
                    contract: contract,
                    fromAccount: accountEntity.accountName,
                    toAccount: toAccount,
                    quantity: quantity,
                    memo: memo,
                    authorizingPrivateKey: privateKey
                ).flatMap { response in
                    if (response.success()) {
                        return self.insertTransactionLog.insert(
                            transactionId: response.data!.transaction_id
                        ).map { _ in
                            TransferConfirmResult.onSuccess(actionReceipt: ActionReceipt(
                                transactionId: response.data!.transaction_id,
                                authorizingAccountName: fromAccount
                            ))
                        }
                    } else {
                        return self.transferError(transferError: response.error!)
                    }
                }.catchErrorJustReturn(TransferConfirmResult.onError)
            }.catchErrorJustReturn(TransferConfirmResult.onError)
        }.asObservable().startWith(TransferConfirmResult.onProgress)
    }
    
    private func transferError(transferError: TransferError) -> Single<TransferConfirmResult> {
        switch transferError {
        case .generic:
            return Single.just(TransferConfirmResult.onError)
        case .withLog(let log):
            return Single.just(TransferConfirmResult.errorWithLog(log: log))
        }
    }
}
