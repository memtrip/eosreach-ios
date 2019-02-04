import Foundation

class StubApi {
    
    init() {
    }
    
    var getInfo: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_info$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_infoJson())
        })
    )
    
    
    var getAccount: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_account$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_account_stakedJson())
        })
    )
    
    var getKeyAccounts: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/history/get_key_accounts$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_key_accountsJson())
        })
    )
    
    var getCurrencyBalance: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_currency_balance$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_sys_currency_balanceJson())
        })
    )
    
    var getCustomTokensTableRows: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_customtokenJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_customtokenJson())
        })
    )
    
    var getTableRowsProducerJson: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_producerjsonJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_producerjsonJson())
        })
    )
    
    var getTableRowsProducerSingleJson: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_producerjson_singleJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_producerjson_singleJson())
        })
    )
    
    var getTableRowsProxyVoter: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_regproxyinfoJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_regproxyinfoJson())
        })
    )
    
    var getTableRowsSingleProxyVoter: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_regproxyinfoJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_regproxyinfo_singleJson())
        })
    )
    
    var getTableRowsAllocatedBandwidth: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_table_rows$"),
            bodyMatcher: jsonString(R.file.request_get_table_rows_delegated_bandwidthJson())
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_table_rows_delegated_bandwidthJson())
        })
    )

    var getActions: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/history/get_actions$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_actionsJson())
        })
    )

    var getBlockProducers: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/get_producers$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_get_producersJson())
        })
    )
    
    var pushTransaction: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_endpoint_url(),
            urlMatcher: regex("v1/chain/push_transaction$")
        ),
        request: BasicStubRequest(code: 400, body: {
            return readJson(R.file.error_push_transaction_logJson())
        })
    )
    
    var getPriceForCurrency: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_reach_endpoint_url(),
            urlMatcher: regex("price/(.*)$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_priceJson())
        })
    )
    
    var createAccount: Stub = Stub(
        matcher: StubMatcher(
            rootUrl: R.string.appStrings.app_reach_endpoint_url(),
            urlMatcher: regex("createAccount$")
        ),
        request: BasicStubRequest(code: 200, body: {
            return readJson(R.file.happy_path_create_accountJson())
        })
    )
    
    func stubs() -> Array<Stub> {
        return [
            getInfo,
            getAccount,
            getKeyAccounts,
            getCurrencyBalance,
            getCustomTokensTableRows,
            getTableRowsProducerJson,
            getTableRowsProducerSingleJson,
            getTableRowsProxyVoter,
            getTableRowsSingleProxyVoter,
            getTableRowsAllocatedBandwidth,
            getActions,
            getBlockProducers,
            pushTransaction,
            getPriceForCurrency,
            createAccount
        ]
    }
}

func regex(_ pattern: String) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: [])
}

func readJson(_ path: URL?) -> Data {
    if let path = path {
        return try! Data(contentsOf: path, options: .mappedIfSafe)
    } else {
        fatalError("Path not defined")
    }
}

func jsonString(_ path: URL?) -> String {
    if let jsonString = String(data: readJson(path), encoding: String.Encoding.utf8) {
        return jsonString
    } else {
        fatalError("Could not parse body matcher JSON")
    }
}
