import Foundation
import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import stub

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
    
    lazy var actionsRobot: ActionsRobot = {
        return orchestra.actionsRobot
    }()

    lazy var transferRobot: TransferRobot = {
        return orchestra.transferRobot
    }()
    
    lazy var transactionRobot: TransactionRobot = {
        return orchestra.transactionRobot
    }()
    
    lazy var settingsRobot: SettingsRobot = {
        return orchestra.settingsRobot
    }()
    
    override func setUp() {
        StubUrlSession.shared.stubApi = configure(stubApi: StubApi())
        (UIApplication.shared.delegate as! AppDelegate).clearData()
        (UIApplication.shared.delegate as! AppDelegate).resetApplicationState()
    }
    
    func configure(stubApi: StubApi) -> StubApi {
        return stubApi
    }
}
