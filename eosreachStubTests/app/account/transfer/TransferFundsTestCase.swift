import Foundation
@testable import stub

class TransferFundsTestCase : StubTestCase {
    
    func testTransferFunds() {
        
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
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
        
        transactionRobot
            .verifyTransactionLogScreen()
        
        commonRobot
            .selectToolbarBackButton()
        
        transferRobot.pressConfirmTransferCta()
        
        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        balanceRobot.verifyBalanaceScreen()
        
        // confirm that the side navigation functions correctly, issues
        // with the backstack can break this functionality!
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectMenu()
            it.selectMenuImportKey()
        }
        
        importKeyRobot.verifyImportKeyScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        
        let request = QueuedStubRequest(requests: LinkedList<StubRequest>().apply { it in
            it.append(BasicStubRequest(
                code: 400,
                body: {
                    readJson(R.file.error_push_transaction_logJson())
                }
            ))
            it.append(BasicStubRequest(
                code: 200,
                body: {
                    readJson(R.file.happy_path_push_transaction_logJson())
                }
            ))
        })
        
        stubApi.pushTransaction = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/push_transaction$")
            ),
            request: request
        )
        
        return stubApi
    }
}
