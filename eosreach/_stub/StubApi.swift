import Foundation

open class StubApi {
    
    open func getInfo() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_info$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_infoJson())
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
                return self.readJson(R.file.happy_path_get_account_unstakedJson())
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
                return self.readJson(R.file.happy_path_get_key_accountsJson())
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
                return self.readJson(R.file.happy_path_get_sys_currency_balanceJson())
            })
        )
    }
    
    open func getCustomTokensTableRows() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_customtokenJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_customtokenJson())
            })
        )
    }
    
    open func getTableRowsProducerJson() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_producerjsonJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_producerjsonJson())
            })
        )
    }
    
    open func getTableRowsProducerSingleJson() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_producerjson_singleJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_producerjson_singleJson())
            })
        )
    }
    
    open func getTableRowsProxyVoter() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_regproxyinfoJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_regproxyinfoJson())
            })
        )
    }
    
    open func getTableRowsSingleProxyVoter() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_regproxyinfoJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_regproxyinfo_singleJson())
            })
        )
    }
    
    open func getTableRowsAllocatedBandwidth() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/chain/get_table_rows$"),
                bodyMatcher: self.jsonString(R.file.request_get_table_rows_delegated_bandwidthJson())
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_table_rows_delegated_bandwidthJson())
            })
        )
    }

    open func getActions() -> Stub {
        return Stub(
            matcher: StubMatcher(
                rootUrl: R.string.appStrings.app_endpoint_url(),
                urlMatcher: self.regex("v1/history/get_actions$")
            ),
            request: BasicStubRequest(code: 200, body: {
                return self.readJson(R.file.happy_path_get_actionsJson())
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
                return self.readJson(R.file.happy_path_get_producersJson())
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
                return self.readJson(R.file.error_push_transaction_logJson())
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
                return self.readJson(R.file.happy_path_priceJson())
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
                return self.readJson(R.file.happy_path_create_accountJson())
            })
        )
    }
    
    func stubs() -> Array<Stub> {
        return [
            getInfo(),
            getAccount(),
            getKeyAccounts(),
            getCurrencyBalance(),
            getCustomTokensTableRows(),
            getTableRowsProducerJson(),
            getTableRowsProducerSingleJson(),
            getTableRowsProxyVoter(),
            getTableRowsSingleProxyVoter(),
            getTableRowsAllocatedBandwidth(),
            getActions(),
            getBlockProducers(),
            pushTransaction(),
            getPriceForCurrency(),
            createAccount()
        ]
    }
    
    private func regex(_ pattern: String) -> NSRegularExpression {
        return try! NSRegularExpression(pattern: "v1/chain/get_info$", options: [])
    }
    
    private func readJson(_ path: URL?) -> Data {
        if let path = path {
            return try! Data(contentsOf: path, options: .mappedIfSafe)
        } else {
            fatalError("Path not defined")
        }
    }
    
    private func jsonString(_ path: URL?) -> String {
        if let jsonString = String(data: self.readJson(path), encoding: String.Encoding.utf8) {
            return jsonString
        } else {
            fatalError("Could not parse body matcher JSON")
        }
    }
}
