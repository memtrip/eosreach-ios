import Foundation
import XCTest

class TestCase : XCTestCase {

    let orchestra: Orchestra = BasicOrchestra()
    let importKeyOrchestra = ImportKeyOrchestra()
    
    lazy var commonRobot: CommonRobot = {
        return orchestra.commonRobot
    }()
    
    lazy var splashRobot: SplashRobot = {
        return orchestra.splashRobot
    }()
    
    lazy var importKeyRobot: ImportKeyRobot = {
        return orchestra.importKeyRobot
    }()
    
    lazy var createAccountRobot: CreateAccountRobot = {
        return orchestra.createAccountRobot
    }()
    
    lazy var accountNavigationRobot: AccountNavigationRobot = {
        return orchestra.accountNavigationRobot
    }()

    lazy var accountRobot: AccountRobot = {
        return orchestra.accountRobot
    }()
    
    lazy var balanceRobot: BalanceRobot = {
        return orchestra.balanceRobot
    }()

    lazy var voteRobot: VoteRobot = {
        return orchestra.voteRobot
    }()
    
    lazy var resourcesRobot: ResourcesRobot = {
        return orchestra.resourcesRobot
    }()
    
    lazy var bandwidthRobot: BandwidthRobot = {
        return orchestra.bandwidthRobot
    }()
    
    lazy var ramRobot: RamRobot = {
        return orchestra.ramRobot
    }()
    
    lazy var actionsRobot: ActionsRobot = {
        return orchestra.actionsRobot
    }()

    lazy var transferRobot: TransferRobot = {
        return orchestra.transferRobot
    }()
    
    lazy var transactionRobot: TransactionRobot = {
        return orchestra.transactionRobot
    }()
    
    lazy var blockProducerRobot: BlockProducerRobot = {
        return orchestra.blockProducerRobot
    }()
    
    lazy var proxyRobot: ProxyRobot = {
        return orchestra.proxyRobot
    }()
    
    lazy var searchRobot: SearchRobot = {
        return orchestra.searchRobot
    }()
    
    lazy var settingsRobot: SettingsRobot = {
        return orchestra.settingsRobot
    }()
}
