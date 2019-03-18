import Foundation
@testable import stub

class UnDelegateBandwidthTestCase : StubTestCase {
    
    func testUnDelegateBandwidth() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectResourcesTab()
        }
        
        resourcesRobot.begin { it in
            it.verifyResourcesScreen()
            it.selectBandwidthButton()
        }
        
        bandwidthRobot.begin { it in
            it.selectUndelegateTab()
            it.enterNetBalance(value: "0.0009", prefix: "undelegate_bandwidth_")
            it.enterCpuBalance(value: "10.3921", prefix: "undelegate_bandwidth_")
            it.enterTargetAccount(value: "memtripissue", prefix: "undelegate_bandwidth_")
            it.verifyBandwidthConfirmCpuBalance(balance: "10.3921 SYS")
            it.verifyBandwidthConfirmNetBalance(balance: "0.0009 SYS")
            it.selectBandwidthConfirmButton()
        }
        
        transactionRobot
            .verifyTransactionLogScreen()
        
        commonRobot
            .selectToolbarBackButton()
        
        bandwidthRobot
            .selectBandwidthConfirmButton()
        
        transactionRobot.begin { it in
            it.verifyTransactionReceiptScreen()
            it.selectDoneButton()
        }
        
        resourcesRobot.verifyResourcesScreen()
        
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
