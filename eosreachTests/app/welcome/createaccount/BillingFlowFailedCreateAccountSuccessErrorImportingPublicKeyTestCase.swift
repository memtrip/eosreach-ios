import Foundation
@testable import stub

class BillingFlowFailedCreateAccountSuccessErrorImportingPublicKeyTestCase : TestCase {
    
    func testBillingFlowFailedCreateAccountSuccessErrorImportingPublicKey() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyAccountCreatedScreen()
            it.selectAccountCreatedDoneButton()
            it.verifyImportKeyErrorScreen()
            it.selectImportKeySettingsButton()
        }
        
        settingsRobot.verifySettingsScreen()
        
        commonRobot.selectToolbarBackButton()
        
        createAccountRobot.begin { it in
            it.verifyImportKeyErrorScreen()
            it.selectImportKeySyncButton()
        }
        
        accountRobot.verifyAccountScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        
        let request = QueuedStubRequest(requests: LinkedList<StubRequest>().apply { it in
            it.append(BasicStubRequest(code: 200, body: {
                 readJson(R.file.happy_path_get_key_accounts_emptyJson())
            }))
            it.append(BasicStubRequest(code: 200, body: {
                readJson(R.file.happy_path_get_key_accountsJson())
            }))
        })
        
        stubApi.getKeyAccounts = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/history/get_key_accounts$")
            ),
            request: request
        )
        
        return stubApi
    }
}
