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
}
