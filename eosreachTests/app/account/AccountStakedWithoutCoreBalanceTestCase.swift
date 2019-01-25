import Foundation
@testable import stub

class AccountStakedWithoutCoreBalanceTestCase : TestCase {
    
    func go() {
        importKeyOrchestra.go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        accountRobot.verifyAccountScreen()
        accountRobot.verifyAvailableBalance()
    }
    
    override func configure(stubApi: StubApi) -> StubApi {
        stubApi.getInfo = Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: regex("v1/chain/get_info$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return readJson(R.file.happy_path_get_infoJson())
            })
        )
        return stubApi
    }
}
