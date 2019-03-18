import Foundation
@testable import dev

class BuyRamTestCase : DevTestCase {
    
    func testBuyRam() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectResourcesTab()
        }
        
        resourcesRobot.begin { it in
            it.verifyResourcesScreen()
            it.selectRamButton()
        }
        
        ramRobot.begin { it in
            it.verifyBuyRamScreen()
            it.enterBuyRamAmount(amount: "10")
            it.pressBuyButton()
            it.verifyConfirmBuyRamScreen(ramValue: "10")
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
