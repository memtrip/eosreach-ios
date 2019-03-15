import Foundation

class RamRobot : Robot {
    
    //
    // Buy ram
    //
    func verifyBuyRamScreen() {
        
        onView(withId("buy_ram_amount_input"))
            .matches(isDisplayed())
        
        onView(withId("buy_ram_estimated_value_label"))
            .matches(isDisplayed())
        
        onView(withId("buy_ram_cta_button"))
            .matches(isDisplayed())
    }
    
    func enterBuyRamAmount(amount: String) {
        onView(withId("buy_ram_amount_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(amount))
    }
    
    func verifyBuyRamEstimatedCost(value: String) {
        onView(withId("buy_ram_estimated_value_label"))
            .matchesNext(isDisplayed())
            .matches(withText("Estimated cost: \(value)"))
    }
    
    func pressBuyButton() {
        onView(withId("buy_ram_cta_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyConfirmBuyRamScreen() {
        onView(withId("confirm_buy_ram_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("confirm_buy_ram_kb_value"))
            .matchesNext(isDisplayed())
            .matches(withText("10"))
        
        onView(withId("confirm_buy_ram_price_value"))
            .matchesNext(isDisplayed())
            .matches(withText("0.5084 SYS"))
        
        onView(withId("confirm_buy_ram_cta"))
            .matches(isDisplayed())
    }
    
    func selectConfirmRamCta() {
        onView(withId("confirm_buy_ram_cta"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    //
    // Sell ram
    //
    func verifySellRamScreen() {
        
        onView(withId("sell_ram_amount_input"))
            .matches(isDisplayed())
        
        onView(withId("sell_ram_estimated_value_label"))
            .matches(isDisplayed())
        
        onView(withId("sell_ram_cta_button"))
            .matches(isDisplayed())
    }
    
    func enterSellRamAmount(amount: String) {
        onView(withId("sell_ram_amount_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(amount))
    }
    
    func verifySellRamEstimatedCost(value: String) {
        onView(withId("sell_ram_estimated_value_label"))
            .matchesNext(isDisplayed())
            .matches(withText("Estimated cost: \(value)"))
    }
    
    func pressSellButton() {
        onView(withId("sell_ram_cta_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
