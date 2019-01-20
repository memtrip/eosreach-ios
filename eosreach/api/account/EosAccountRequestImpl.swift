import Foundation
import RxSwift
import eosswift

class EosAccountRequestImpl : EosAccountRequest {

    let chainApi: ChainApi = ChainApiModule.create()

    func getAccount(accountName: String) -> Single<Result<EosAccount, AccountError>> {

        return chainApi.getAccount(body: AccountName(account_name: accountName)).map { response in
            if (response.success) {
                let account = response.body!
                let stakedNetBalance = self.stakedNetBalance(selfDelegatedBandwidth: account.self_delegated_bandwidth)
                let stakedCpuBalance = self.stakedCpuBalance(selfDelegatedBandwidth: account.self_delegated_bandwidth)
                let balance = try self.inferBalanceSymbol(
                    balance: account.core_liquid_balance,
                    netBalance: stakedNetBalance,
                    cpuBalance: stakedCpuBalance,
                    totalResources: account.total_resources
                )
                let eosAccount = EosAccount(
                    accountName: account.account_name,
                    balance: balance,
                    netResource: EosAccountResource(
                        used: account.net_limit.used.value,
                        available: account.net_limit.available.value,
                        staked: stakedNetBalance,
                        delegated: self.delegatedNetBalance(
                            totalResources: account.total_resources,
                            stakedNetBalance: stakedNetBalance)
                    ),
                    cpuResource: EosAccountResource(
                        used: account.cpu_limit.used.value,
                        available: account.cpu_limit.available.value,
                        staked: stakedCpuBalance,
                        delegated: self.delegatedCpuBalance(
                            totalResources: account.total_resources,
                            stakedCpuBalance: stakedCpuBalance)),
                    ramResource: EosAccountResource(
                        used: account.ram_usage.value,
                        available: account.ram_quota.value,
                        staked: nil,
                        delegated: nil),
                    eosAcconuntVote: self.eosCurrentVote(voterInfo: account.voter_info),
                    eosRefundRequest: self.eosRefundRequest(refundRequest: account.refund_request))

                return Result<EosAccount, AccountError>(data: eosAccount)
            } else {
                return Result<EosAccount, AccountError>(error: AccountError.failedRetrievingAccount(
                    code: response.statusCode, body: ""))
            }
        }.catchError { error in
            return Single.just(Result<EosAccount, AccountError>(error: AccountError.genericError))
        }
    }

    private func inferBalanceSymbol(
        balance: String?,
        netBalance: Balance?,
        cpuBalance: Balance?,
        totalResources: TotalResources?
    ) throws -> Balance {
        if (balance != nil) {
            return BalanceFormatter.deserialize(balance: balance!)
        } else if (netBalance != nil) {
            return BalanceFormatter.create(amount: 0.0, symbol: netBalance!.symbol)
        } else if (cpuBalance != nil) {
            return BalanceFormatter.create(amount: 0.0, symbol: cpuBalance!.symbol)
        } else if (totalResources != nil) {
            return BalanceFormatter.deserialize(balance: totalResources!.cpu_weight)
        } else {
            throw InferBalanceError.genericError
        }
    }

    private func stakedNetBalance(selfDelegatedBandwidth: SelfDelegatedBandwidth?) -> Balance? {
        if (selfDelegatedBandwidth != nil) {
            return BalanceFormatter.deserialize(balance: selfDelegatedBandwidth!.net_weight)
        } else {
            return nil
        }
    }

    private func delegatedNetBalance(totalResources: TotalResources?, stakedNetBalance: Balance?) -> Balance? {
        let stakedNetBalanceAmount = stakedNetBalance != nil ? stakedNetBalance!.amount : 0.0
        if (totalResources != nil) {
            let totalCpuBalance = BalanceFormatter.deserialize(balance: totalResources!.net_weight)
            let delegatedBalance = totalCpuBalance.amount - stakedNetBalanceAmount
            return BalanceFormatter.create(amount: delegatedBalance, symbol: totalCpuBalance.symbol)
        } else {
            return nil
        }
    }

    private func stakedCpuBalance(selfDelegatedBandwidth: SelfDelegatedBandwidth?) -> Balance? {
        if (selfDelegatedBandwidth != nil) {
            return BalanceFormatter.deserialize(balance: selfDelegatedBandwidth!.cpu_weight)
        } else {
            return nil
        }
    }

    private func delegatedCpuBalance(totalResources: TotalResources?, stakedCpuBalance: Balance?) -> Balance? {
        let stakedCpuBalanceAmount = stakedCpuBalance != nil ? stakedCpuBalance!.amount : 0.0
        if (totalResources != nil) {
            let totalCpuBalance = BalanceFormatter.deserialize(balance: totalResources!.cpu_weight)
            let delegateBalance = totalCpuBalance.amount - stakedCpuBalanceAmount
            return BalanceFormatter.create(amount: delegateBalance, symbol: totalCpuBalance.symbol)
        } else {
            return nil
        }
    }

    private func eosRefundRequest(refundRequest: RefundRequest?) -> EosRefundRequest? {
        if (refundRequest != nil) {
            return EosRefundRequest(
                owner: refundRequest!.owner,
                requestTime: refundRequest!.request_time,
                net: BalanceFormatter.deserialize(balance: refundRequest!.net_amount),
                cpu: BalanceFormatter.deserialize(balance: refundRequest!.cpu_amount))
        } else {
            return nil
        }
    }

    private func eosCurrentVote(voterInfo: VoterInfo?) -> EosAccountVote? {
        if (voterInfo != nil) {
            return EosAccountVote(
                proxyVoterAccountName: voterInfo!.proxy,
                producers: voterInfo!.producers,
                staked: voterInfo!.staked.value,
                lastVoteWeight: voterInfo!.last_vote_weight,
                proxiedVoteWeight: voterInfo!.proxied_vote_weight,
                isProxyVoter: voterInfo!.is_proxy == 1,
                hasDelegatedProxyVoter: voterInfo!.proxy != "")
        } else {
            return nil
        }
    }

    enum InferBalanceError: Error {
        case genericError
    }
}
