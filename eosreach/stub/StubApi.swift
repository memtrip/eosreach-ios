import Foundation

open class StubApi {
    
    open func getInfo() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_info$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_info.json")
            })
        )
    }
    
    open func getAccount() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_account$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_account_unstaked.json")
            })
        )
    }
    
    open func getKeyAccounts() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/history/get_key_accounts$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_key_accounts.json")
            })
        )
    }
    
    open func getCurrencyBalance() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_currency_balance$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_sys_currency_balance.json")
            })
        )
    }
    
    open func getCustomTokensTableRows() -> Stub {
        fatalError("requires a request body matcher")
    }
    
    open func getTableRowsProducerJson() -> Stub {
        fatalError("requires a request body matcher")
    }
    
    open func getTableRowsProducerSingleJson() -> Stub {
        fatalError("requires a request body matcher")
    }
    
    open func getTableRowsProxyVoter() -> Stub {
        fatalError("requires a request body matcher")
    }
    
    open func getTableRowsSingleProxyVoter() -> Stub {
        fatalError("requires a request body matcher")
    }
    
    open func getTableRowsAllocatedBandwidth() -> Stub {
        fatalError("requires a request body matcher")
    }

    open func getActions() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/history/get_actions$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_actions.json")
            })
        )
    }
    
    open func getBlockProducers() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_producers$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_get_producers.json")
            })
        )
    }
    
    open func pushTransaction() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/push_transaction$")
            ),
            request: BasicStubRequest(code: 400, body: {
                return self.readJson("stub/error/error_push_transaction_log.json")
            })
        )
    }
    
    open func getPriceForCurrency() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("price/(.*)$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_price.json")
            })
        )
    }
    
    open func createAccount() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("createAccount$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson("stub/happypath/happy_path_create_account.json")
            })
        )
    }
    
    private func regex(_ pattern: String) -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "v1/chain/get_info$", options: [])
    }
    
    private func readJson(_ path: String) -> Data {
        if let path = Bundle.main.path(forResource: path, ofType: "json") {
            return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        } else {
            fatalError("File not found at path: \(path)")
        }
    }
}
