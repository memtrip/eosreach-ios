import Foundation
import eosswift
import Material

struct AccountAction {
    let tranactionId: String
    let accountActionSequence: Int
    let from: String
    let to: String
    let memo: String
    let formattedDate: String
    let quantityString: String
    let quantity: Balance
    let currencyPairValue: String
    let transferIncoming: Bool
    let transferInteractingAccountName: String
    let contractAccountBalance: ContractAccountBalance

    static func create(
        action: HistoricAccountAction,
        contractAccountBalance: ContractAccountBalance
    ) -> AccountAction {
        let data = action.action_trace.act.data
        let from = data["from"]!.jsonValue as! String
        let to = data["to"]!.jsonValue as! String
        let memo = data["memo"]!.jsonValue as! String
        let quantity = data["quantity"]!.jsonValue as! String
        let quantityValue = BalanceFormatter.deserialize(balance: quantity)
        let transferIncoming = contractAccountBalance.accountName == to
        let transferInteractingAccountName = transferIncoming ? from : to

        return AccountAction(
            tranactionId: action.action_trace.trx_id,
            accountActionSequence: action.account_action_seq,
            from: from,
            to: to,
            memo: memo,
            formattedDate: action.block_time.fullDateTime(),
            quantityString: quantity,
            quantity: quantityValue,
            currencyPairValue: parseCurrencyPair(balance: quantityValue, contractAccountBalance: contractAccountBalance),
            transferIncoming: transferIncoming,
            transferInteractingAccountName: transferInteractingAccountName,
            contractAccountBalance: contractAccountBalance)
    }

    static func parseCurrencyPair(balance: Balance, contractAccountBalance: ContractAccountBalance) -> String {
        if (!contractAccountBalance.exchangeRate.unavailable) {
            return CurrencyPairFormatter.formatAmountCurrencyPairValue(amount: balance.amount, eosPrice: contractAccountBalance.exchangeRate)
        } else {
            return "-"
        }
    }
}

protocol ActionType {
}
