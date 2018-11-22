import Foundation
import RxSwift
import eosswift

class ConfirmBandwidthViewModel: MxViewModel<ConfirmBandwidthIntent, ConfirmBandwidthResult, ConfirmBandwidthViewState> {
    
    private let bandwidthRequest = BandwidthRequestImpl()
    private let getAccountByName = GetAccountByName()
    private let eosKeyManager = EosKeyManagerImpl()
    
    override func dispatcher(intent: ConfirmBandwidthIntent) -> Observable<ConfirmBandwidthResult> {
        switch intent {
        case .idle:
            return just(ConfirmBandwidthResult.idle)
        case .start(let bandwidthFormBundle):
            return just(ConfirmBandwidthResult.populate(bandwidthFormBundle: bandwidthFormBundle))
        case .commit(let bandwidthBundle):
            return commit(bandwidthFormBundle: bandwidthBundle)
        }
    }

    override func reducer(previousState: ConfirmBandwidthViewState, result: ConfirmBandwidthResult) -> ConfirmBandwidthViewState {
        switch result {
        case .idle:
            return ConfirmBandwidthViewState.idle
        case .populate(let bandwidthFormBundle):
            return ConfirmBandwidthViewState.populate(bandwidthFormBundle: bandwidthFormBundle)
        case .onProgress:
            return ConfirmBandwidthViewState.onProgress
        case .onError:
            return ConfirmBandwidthViewState.onError
        case .withLog(let log):
            return ConfirmBandwidthViewState.withLog(log: log)
        case .navigateToTransactionConfirmed(let transactionId):
            return ConfirmBandwidthViewState.navigateToTransactionConfirmed(transactionId: transactionId)
        }
    }
    
    private func commit(bandwidthFormBundle: BandwidthFormBundle) -> Observable<ConfirmBandwidthResult> {
        return getAccountByName.select(accountName: bandwidthFormBundle.contractAccountBalance.accountName).flatMap { accountEntity in
            return self.eosKeyManager.getPrivateKey(eosPublicKey: accountEntity.publicKey).flatMap { privateKey in
                switch bandwidthFormBundle.type {
                case .delegate:
                    return self.delegateBandwidth(
                        fromAccount: bandwidthFormBundle.contractAccountBalance.accountName,
                        toAccount: bandwidthFormBundle.targetAccount,
                        netAmount: bandwidthFormBundle.netAmount,
                        cpuAmount: bandwidthFormBundle.cpuAmount,
                        transfer: bandwidthFormBundle.transfer,
                        privateKey: privateKey)
                case .undelegate:
                    return self.undelegateBandwidth(
                        fromAccount: bandwidthFormBundle.contractAccountBalance.accountName,
                        toAccount: bandwidthFormBundle.targetAccount,
                        netAmount: bandwidthFormBundle.netAmount,
                        cpuAmount: bandwidthFormBundle.cpuAmount,
                        privateKey: privateKey)
                }
            }.catchErrorJustReturn(ConfirmBandwidthResult.onError)
        }.catchErrorJustReturn(ConfirmBandwidthResult.onError).asObservable().startWith(ConfirmBandwidthResult.onProgress)
    }
    
    private func delegateBandwidth(
        fromAccount: String,
        toAccount: String,
        netAmount: Balance,
        cpuAmount: Balance,
        transfer: Bool,
        privateKey: EOSPrivateKey
    ) -> Single<ConfirmBandwidthResult> {
        return bandwidthRequest.delegate(
            fromAccount: fromAccount,
            toAccount: toAccount,
            netAmount: BalanceFormatter.formatEosBalance(balance: netAmount),
            cpuAmount: BalanceFormatter.formatEosBalance(balance: cpuAmount),
            transfer: transfer,
            authorizingPrivateKey: privateKey,
            transactionExpiry: Date.defaultTransactionExpiry()
        ).map { response in
            if (response.success()) {
                return ConfirmBandwidthResult.navigateToTransactionConfirmed(transactionId: response.data!.transactionId)
            } else {
                switch response.error! {
                case .transactionError(let body):
                    return ConfirmBandwidthResult.withLog(log: body)
                case .genericError:
                    return ConfirmBandwidthResult.onError
                }
            }
        }
    }
    
    private func undelegateBandwidth(
        fromAccount: String,
        toAccount: String,
        netAmount: Balance,
        cpuAmount: Balance,
        privateKey: EOSPrivateKey
    ) -> Single<ConfirmBandwidthResult> {
        return bandwidthRequest.undelegate(
            fromAccount: fromAccount,
            toAccount: toAccount,
            netAmount: BalanceFormatter.formatEosBalance(balance: netAmount),
            cpuAmount: BalanceFormatter.formatEosBalance(balance: cpuAmount),
            authorizingPrivateKey: privateKey,
            transactionExpiry: Date.defaultTransactionExpiry()
        ).map { response in
            if (response.success()) {
                return ConfirmBandwidthResult.navigateToTransactionConfirmed(transactionId: response.data!.transactionId)
            } else {
                switch response.error! {
                case .transactionError(let body):
                    return ConfirmBandwidthResult.withLog(log: body)
                case .genericError:
                    return ConfirmBandwidthResult.onError
                }
            }
        }
    }
}