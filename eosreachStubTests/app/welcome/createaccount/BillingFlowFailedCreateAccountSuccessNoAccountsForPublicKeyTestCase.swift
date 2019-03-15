import Foundation
@testable import stub

class BillingFlowFailedCreateAccountSuccessNoAccountsForPublicKeyTestCase : TestCase {
    
    func testBillingFlowFailedCreateAccountSuccessNoAccountsForPublicKey() {
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

        //
        //        let request = ErrorOnFirstStubRequest(code: 200, body: {
        //            readJson(R.file.happy_path_get_key_accountsJson())
        //        })
        
        let request = QueuedStubRequest(requests: LinkedList<StubRequest>().apply { it in
            it.append(BasicStubRequest(code: 400))
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
