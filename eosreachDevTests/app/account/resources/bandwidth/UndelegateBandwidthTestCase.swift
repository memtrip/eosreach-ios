import Foundation

class UndelegateBandwidthTestCase : DevTestCase {
    
    func testUndelegateBandwidthError() {
        
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
            it.selectUndelegateTab()
            it.enterNetBalance(value: "0.0001", prefix: "undelegate_bandwidth_")
            it.enterCpuBalance(value: "0.0001", prefix: "undelegate_bandwidth_")
            it.enterTargetAccount(value: "memtripadmin", prefix: "undelegate_bandwidth_")
            it.verifyBandwidthConfirmCpuBalance(balance: "0.0001 EOS")
            it.verifyBandwidthConfirmNetBalance(balance: "0.0001 EOS")
            it.selectBandwidthConfirmButton()
        }
        
        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        resourcesRobot.verifyResourcesScreen()
    }
}
