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
    
    func selectFirstProxyInformationRow() {
        
        onView(
            withIdInParent(
                withIdInTableView("proxy_voter_list_tableview", position: 0, id: "proxy_voter_list_border"),
                id: "proxy_voter_list_information_button"
            )
        )
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func verifyProxyInformation() {
        
        onView(withId("view_proxy_voter_toolbar"))
            .matches(isDisplayed())
        
        onView(withId("view_proxy_voter_container"))
            .matches(isDisplayed())
        
        onView(allOf(
            withId("view_proxy_voter_image"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matches(isDisplayed())
        
        onView(allOf(
            withId("view_proxy_voter_blurb"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matches(isDisplayed())
        
        onView(allOf(
            withId("view_proxy_voter_website"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matches(isDisplayed())
        
        onView(allOf(
            withId("view_proxy_voter_view_account"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matches(isDisplayed())
        
        onView(allOf(
            withId("view_proxy_voter_summary"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matches(isDisplayed())
    }
    
    func selectViewAccount() {
       
        onView(allOf(
            withId("view_proxy_voter_view_account"),
            ancestorOf(withId("view_proxy_voter_container"))
        )).matchesNext(isDisplayed()).perform(click())
    }
}
