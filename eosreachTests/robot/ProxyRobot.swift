import Foundation

class ProxyRobot: Robot {

    func verifyExploreProxyAccounts() {
        
        onView(withId("proxy_voter_list_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("proxy_voter_list_tableview"))
            .matches(isDisplayed())
    }
    
    func selectFirstProxyRow() {
        
        onView(
            withIdInParent(
                withIdInTableView("proxy_voter_list_tableview", position: 0, id: "proxy_voter_list_border"),
                id: "proxy_voter_list_name"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
}
