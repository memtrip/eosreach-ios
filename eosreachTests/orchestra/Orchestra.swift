import Foundation

protocol Orchestra {
}

class BasicOrchestra : Orchestra {
}

extension Orchestra {
    
    var commonRobot: CommonRobot {
        return CommonRobot()
    }
    
    var splashRobot: SplashRobot {
        return SplashRobot()
    }
    
    var importKeyRobot: ImportKeyRobot {
        return ImportKeyRobot()
    }
 
    var createAccountRobot: CreateAccountRobot {
        return CreateAccountRobot()
    }

    var accountNavigationRobot: AccountNavigationRobot {
        return AccountNavigationRobot()
    }

    var accountRobot: AccountRobot {
        return AccountRobot()
    }
    
    var balanceRobot: BalanceRobot {
        return BalanceRobot()
    }

    var voteRobot: VoteRobot {
        return VoteRobot()
    }
    
    var resourcesRobot: ResourcesRobot {
        return ResourcesRobot()
    }

    var actionsRobot: ActionsRobot {
        return ActionsRobot()
    }
    
    var transferRobot: TransferRobot {
        return TransferRobot()
    }
    
    var transactionRobot: TransactionRobot {
        return TransactionRobot()
    }
    
    var blockProducerRobot: BlockProducerRobot {
        return BlockProducerRobot()
    }
    
    var proxyRobot: ProxyRobot {
        return ProxyRobot()
    }
    
    var settingsRobot: SettingsRobot {
        return SettingsRobot()
    }
}
