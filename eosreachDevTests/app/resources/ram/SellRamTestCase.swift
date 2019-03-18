import Foundation
@testable import dev

class SellRamTestCase : DevTestCase {
    
    func testSellRam() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectResourcesTab()
        }
        
        resourcesRobot.begin { it in
            it.verifyResourcesScreen()
            it.selectRamButton()
            it.selectSellTab()
        }
        
        ramRobot.begin { it in
            it.verifySellRamScreen()
            it.enterSellRamAmount(amount: "10")
            it.pressSellButton()
            it.verifyConfirmSellRamScreen(ramValue: "10")
            it.selectConfirmRamCta()
        }
        
        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        accountRobot.verifyAccountScreen()
        resourcesRobot.verifyResourcesScreen()
    }
}
