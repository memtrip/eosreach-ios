import Foundation
@testable import stub

class BillingFlowSuccessCreateAccountFailedAccountsForPublicKeyTestCase : TestCase {
    
    func testBillingFlowSuccessCreateAccountFailedAccountsForPublicKey() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyAccountCreatedScreen()
            it.selectAccountCreatedDoneButton()
        }
        
        accountRobot.verifyAccountScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        stubApi.createAccount = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_reach_endpoint_url(),
                urlMatcher: regex("createAccount$")
            ),
            request: BasicStubRequest(code: 400)
        )
        
        stubApi.getKeyAccounts = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/history/get_key_accounts$")
            ),
            request: BasicStubRequest(code: 200, body: {
                readJson(R.file.happy_path_get_key_accountsJson())
            })
        )
        
        return stubApi
    }
}
