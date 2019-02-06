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
    
    func verifyVoteForProducersScreen() {
        
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
    
    func selectVoteForProxy() {
        
        onView(withId("vote_cast_proxy_button"))
            .matchesNext(isDisplayed())
            .perform(click())
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
}
