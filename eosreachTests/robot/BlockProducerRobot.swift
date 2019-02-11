import Foundation

class BlockProducerRobot: Robot {
 
    func verifyBlockProducerListScreen() {
        onView(withId("block_producer_list_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("block_producer_list_tableview"))
            .matches(isDisplayed())
    }
    
    func verifyBlockProducerListFirstAccountRow() {
        onView(
            withIdInParent(
                withIdInTableView("block_producer_list_tableview", position: 0, id: "block_producer_list_cell_border"),
                id: "block_producer_list_cell_owner"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("eosnewyorkio"))
        
        onView(
            withIdInParent(
                withIdInTableView("block_producer_list_tableview", position: 0, id: "block_producer_list_cell_border"),
                id: "block_producer_list_cell_account_name"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("EOS New York"))
    }
    
    func selectFirstBlockProducerRow() {
        onView(
            withIdInParent(
                withIdInTableView("block_producer_list_tableview", position: 0, id: "block_producer_list_cell_border"),
                id: "block_producer_list_cell_owner"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectBlockProducerListFirstAccountRowInformation() {
        onView(
            withIdInParent(
                withIdInTableView("block_producer_list_tableview", position: 0, id: "block_producer_list_cell_border"),
                id: "block_producer_list_cell_information_button"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyViewBlockProducerInformationScreen(
        name: String,
        website: String,
        email: String
    ) {
 
        onView(withId("view_block_producer_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("view_block_producer_container"))
            .matches(isDisplayed())
        
        onView(allOf(
            withId("view_block_producer_icon"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())
        
        onView(allOf(
            withId("view_block_producer_website_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())
   
        onView(allOf(
            withId("view_block_producer_email_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())
        
        onView(allOf(
            withId("view_block_producer_owner_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())

        onView(allOf(
            withId("view_block_producer_code_of_conduct_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())
        
        onView(allOf(
            withId("view_block_producer_ownership_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matches(isDisplayed())
    }
    
    func selectViewOwnerAccount() {
        onView(allOf(
            withId("view_block_producer_owner_button"),
            ancestorOf(withId("view_block_producer_container")))
        ).matchesNext(isDisplayed()).perform(click())
    }
}
