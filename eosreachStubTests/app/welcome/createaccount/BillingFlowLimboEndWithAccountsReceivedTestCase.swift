import Foundation
@testable import stub

class BillingFlowLimboEndWithAccountsReceivedTestCase : StubTestCase {

    func testBillingFlowLimboEndWithAccountsReceivedTestCase() {
        splashRobot.selectCreateAccount()
        
        createAccountRobot.begin { it in
            it.verifyEnterAccountNameScreen()
            it.typeAccountName(accountName: "memtripissue")
            it.verifyLimboScreen()
            it.selectLimboSettingsButton()
        }
        
        settingsRobot.verifySettingsScreen()
        
        commonRobot.selectToolbarBackButton()
        
        createAccountRobot.begin { it in
            it.selectLimboRetryButton()
            it.verifyLimboScreenNotDisplayed()
            it.verifyAccountCreatedScreen()
            it.selectAccountCreatedDoneButton()
        }
        
        accountRobot.verifyAccountScreen()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        
        let request = ErrorOnFirstStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_key_accountsJson())
        })
        
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
            request: request
        )
        
        return stubApi
    }
}
