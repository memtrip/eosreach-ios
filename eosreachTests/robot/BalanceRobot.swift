import Foundation

class BalanceRobot : Robot {
    
    func verifyBalanaceScreen() {
        
        onView(withId("account_balance_tokens_label"))
            .matches(isDisplayed())
        
        onView(withId("account_balance_scan_for_airdrops"))
            .matches(isDisplayed())
        
        onView(withId("account_balance_tableview"))
            .matches(isDisplayed())
    }
    
    func selectFirstBalanceItem() {
        
        onView(
            withIdInParent(
                withIdInTableView("account_balance_tableview", position: 0, id: "balance_card_border_view"),
                id: "balance_card_amount"
            )
        ).matchesNext(isDisplayed()).perform(click())
    }
}
