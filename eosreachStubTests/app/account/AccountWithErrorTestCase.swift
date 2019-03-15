import Foundation
@testable import stub

class AccountWithErrorTestCase : StubTestCase {
    
    func testAccountWithError() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        commonRobot.begin { it in
            it.verifyErrorView(
                parentId: "account_error_container",
                titleText: "Failed to fetch account",
                bodyText: "If this problem persists please select a different blockchain endpoint in Settings.")
            
            it.selectRetryButton(parentId: "account_error_container")
        }
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectResourcesTab()
        }
        
        resourcesRobot.begin { it in
            it.verifyStakedResources(cpu: "2.2999 SYS", net: "1.0000 SYS")
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {

        let request = ErrorOnFirstStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_account_without_core_liquid_balanceJson())
        })

        stubApi.getAccount = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/get_account$")
            ),
            request: request
        )
        return stubApi
    }
}
