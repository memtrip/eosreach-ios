import Foundation

class ResourcesRenderer {
    
    let layout: ResourcesViewLayout
    
    init(layout: ResourcesViewLayout) {
       self.layout = layout
    }
    
    func render(eosAccount: EosAccount) {
        let netStaked = eosAccount.netResource.staked
        let cpuStaked = eosAccount.cpuResource.staked
        
        if (emptyBalance(netStaked) && emptyBalance(cpuStaked)) {
            layout.emptyStakedResources()
        } else {
            if (netStaked != nil) {
                layout.populateNetStake(formattedBalance: BalanceFormatter.formatEosBalance(balance: netStaked!))
            } else {
                layout.emptyNetStake()
            }
            
            if (cpuStaked != nil) {
                layout.populateCpuStake(formattedBalance: BalanceFormatter.formatEosBalance(balance: cpuStaked!))
            } else {
                layout.emptyCpuStake()
            }
        }
        
        let netDelegated = eosAccount.netResource.delegated
        let cpuDelegated = eosAccount.cpuResource.delegated
        
        if (emptyBalance(netDelegated) && emptyBalance(cpuDelegated)) {
            layout.emptyDelegatedResources()
        } else {
            
            if (netDelegated != nil) {
                layout.populateNetDelegated(formattedBalance: BalanceFormatter.formatEosBalance(balance: netDelegated!))
            } else {
                layout.emptyNetDelegated()
            }
            
            if (cpuDelegated != nil) {
                layout.populateCpuDelegated(formattedBalance: BalanceFormatter.formatEosBalance(balance: cpuDelegated!))
            } else {
                layout.emptyCpuDelegated()
            }
        }
        
        let eosRefundRequest = eosAccount.eosRefundRequest
        if (eosRefundRequest == nil) {
            layout.emptyRefundRequest()
        } else {
            layout.populateRefundRequest(
                formattedNet: BalanceFormatter.formatEosBalance(balance: eosRefundRequest!.net),
                formattedCpu: BalanceFormatter.formatEosBalance(balance: eosRefundRequest!.cpu))
        }
        
        layout.populate(eosAccount: eosAccount)
    }
    
    private func emptyBalance(_ balance: Balance?) -> Bool {
        return balance == nil || balance!.amount <= 0
    }
}

protocol ResourcesViewLayout {
    func emptyStakedResources()
    func populateNetStake(formattedBalance: String)
    func emptyNetStake()
    func populateCpuStake(formattedBalance: String)
    func emptyCpuStake()
    
    func emptyDelegatedResources()
    func populateNetDelegated(formattedBalance: String)
    func emptyNetDelegated()
    func populateCpuDelegated(formattedBalance: String)
    func emptyCpuDelegated()
    
    func emptyRefundRequest()
    func populateRefundRequest(formattedNet: String, formattedCpu: String)
    
    func populate(eosAccount: EosAccount)
}
