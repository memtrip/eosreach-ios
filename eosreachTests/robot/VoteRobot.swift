import Foundation

class VoteRobot : Robot {
    
    func verifyNotVotedScreen() {
        
        onView(withId("vote_title_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_no_vote_body_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_no_vote_castvote_button"))
            .matches(isDisplayed())
    }
    
    func selectVoteForUs() {
        
        onView(withId("vote_no_vote_castvote_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectVoteForProducers() {
        
        onView(withId("vote_cast_producer_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyCastProducerVoteScreen() {
        
        onView(withId("cast_producer_vote_instructions_label"))
            .matches(isDisplayed())
        
        onView(withId("cast_producer_vote_add_button"))
            .matches(isDisplayed())
        
        onView(withId("cast_producer_vote_add_from_list_button"))
            .matches(isDisplayed())
        
        onView(withId("cast_producer_vote_button"))
            .matches(isDisplayed())
        
        onView(withId("cast_producer_vote_list"))
            .matches(isDisplayed())
    }
    
    func selectAddBlockProducerFromList() {
        
        onView(withId("cast_producer_vote_add_from_list_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectAddBlockProducerRow() {
        
        onView(withId("cast_producer_vote_add_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectVoteBlockProducerRow(position: Int) {
        
        onView(
            withIdInParent(
                withIdInTableView("cast_producer_vote_list", position: position, id: "cast_producer_vote_border"),
                id: "cast_producer_vote_input"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func typeVoteBlockProducerRow(position: Int, value: String) {
        
        onView(
            withIdInParent(
                withIdInTableView("cast_producer_vote_list", position: position, id: "cast_producer_vote_border"),
                id: "cast_producer_vote_input"
            )
        )
            .matchesNext(isDisplayed())
            .perform(replaceText(value))
            .perform(dismissKeyboard())
    }
    
    func removeVoteBlockProducerRow(position: Int) {
        
        onView(
            withIdInParent(
                withIdInTableView("cast_producer_vote_list", position: position, id: "cast_producer_vote_border"),
                id: "cast_producer_vote_remove_button"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectVoteBlockProducerButton() {
        onView(withId("cast_producer_vote_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyCastBlockProducerRow() {
        
        onView(
            withIdInParent(
                withIdInTableView("cast_producer_vote_list", position: 0, id: "cast_producer_vote_border"),
                id: "cast_producer_vote_input"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("eosnewyorkio"))
    }
    
    func selectVoteForProxy() {
        
        onView(withId("vote_cast_proxy_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyVotedSingleBlockProducersScreen(value: String) {
        
        onView(withId("vote_title_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_producer_tableview"))
            .matches(isDisplayed())
        
        onView(
            withIdInParent(
                withIdInTableView("vote_producer_tableview", position: 0, id: "vote_producer_cell_border"),
                id: "vote_producer_cell_name"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText(value))
    }
    
    func verifyVotedBlockProducersScreen() {
        
        onView(withId("vote_title_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_producer_tableview"))
            .matches(isDisplayed())
        
        onView(
            withIdInParent(
                withIdInTableView("vote_producer_tableview", position: 0, id: "vote_producer_cell_border"),
                id: "vote_producer_cell_name"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("memtripblock"))

        onView(
            withIdInParent(
                withIdInTableView("vote_producer_tableview", position: 1, id: "vote_producer_cell_border"),
                id: "vote_producer_cell_name"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("eosflareiobp"))
    }
    
    func verifyProxyVoteScreen() {
        
        onView(withId("vote_title_label"))
            .matches(isDisplayed())
        
        onView(withId("vote_proxy_tableview"))
            .matches(isDisplayed())
        
        onView(
            withIdInParent(
                withIdInTableView("vote_proxy_tableview", position: 0, id: "vote_producer_cell_border"),
                id: "vote_producer_cell_name"
            )
        )
            .matchesNext(isDisplayed())
            .matches(withText("memtripproxy"))
    }
    
    func verifyCastProxyVoteScreen() {
        onView(withId("cast_proxy_vote_input"))
            .matches(isDisplayed())
        
        onView(withId("cast_vote_explore_proxy_accounts_button"))
            .matches(isDisplayed())
    }
    
    func verifyCastProxyInputValue(value: String) {
        onView(withId("cast_proxy_vote_input"))
            .matchesNext(isDisplayed())
            .matches(withText(value))
    }
    
    func selectExploreProxyAccountsButton() {
        onView(withId("cast_vote_explore_proxy_accounts_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func typeCastProxyVote(proxyName: String) {
        onView(withId("cast_proxy_vote_input"))
            .matchesNext(isDisplayed())
            .perform(replaceText(proxyName))
    }
    
    func selectCastProxyVoteButton() {
        onView(withId("cast_proxy_vote_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
