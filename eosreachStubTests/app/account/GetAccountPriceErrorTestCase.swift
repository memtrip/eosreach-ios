import Foundation
@testable import stub

class GetAccountPriceErrorTestCase : StubTestCase {
    
    func testAccountWithError() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyUnavailableBalance()
        }
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        stubApi.getPriceForCurrency = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_reach_endpoint_url(),
                urlMatcher: regex("price/(.*)$")
            ),
            request: BasicStubRequest(code: 400)
        )
        return stubApi
    }
}
