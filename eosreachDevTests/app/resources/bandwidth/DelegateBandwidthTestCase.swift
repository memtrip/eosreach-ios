import Foundation

class DelegateBandwidthTestCase : DevTestCase {
    
    func testDelegateBandwidthError() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectResourcesTab()
        }
        
        resourcesRobot.begin { it in
            it.verifyResourcesScreen()
            it.selectBandwidthButton()
        }
        
        bandwidthRobot.begin { it in
            it.enterNetBalance(value: "0.0001", prefix: "delegate_bandwidth_")
            it.enterCpuBalance(value: "0.0001", prefix: "delegate_bandwidth_")
            it.enterTargetAccount(value: "memtripissue", prefix: "delegate_bandwidth_")
            it.verifyBandwidthConfirmCpuBalance(balance: "0.0001 EOS")
            it.verifyBandwidthConfirmNetBalance(balance: "0.0001 EOS")
            it.verifyDelegateFundsPerm()
            it.selectBandwidthConfirmButton()
        }
        
        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        resourcesRobot.verifyResourcesScreen()
    }
}
