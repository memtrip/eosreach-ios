import Foundation

class TransferFundsTestCase : DevTestCase {
    
    func testTransferFunds() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
        }
        
        balanceRobot.begin { it in
            it.verifyBalanaceScreen()
            it.selectFirstBalanceItem()
        }
        
        actionsRobot.selectTransferButton()
        
        transferRobot.begin { it in
            it.verifyTransferScreen()
            it.enterTo(value: "memtripissue")
            it.enterAmount(value: "0.0001")
            it.enterMemo(value: "eosreach ios -> transfer test")
            it.verifyTransferConfirmScreen()
            it.pressConfirmTransferCta()
        }

        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        balanceRobot.verifyBalanaceScreen()
    }
}
