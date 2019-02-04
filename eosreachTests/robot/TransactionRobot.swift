import Foundation

class TransactionRobot : Robot {
    
    func verifyTransactionReceiptScreen() {
        
        onView(withId("transaction_receipt_title_label"))
            .matches(isDisplayed())
        
        onView(withId("transaction_receipt_body_label"))
            .matches(isDisplayed())
        
        onView(withId("transaction_receipt_done_button"))
            .matches(isDisplayed())
        
        onView(withId("transaction_receipt_view_in_explorer_button"))
            .matches(isDisplayed())
    }
    
    func selectDoneButton() {
        
        onView(withId("transaction_receipt_done_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyTransactionLogScreen() {
        
        onView(withId("transaction_log_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("transaction_log_body"))
            .matches(isDisplayed())
    }
}
