import Foundation

class ResourcesRobot : Robot {
    
    func verifyResourcesScreen() {
        onView(withId("resources_title"))
            .matches(isDisplayed())
        
        onView(withId("resources_bandwidth_button"))
            .matches(isDisplayed())
        
        onView(withId("resources_ram_button"))
            .matches(isDisplayed())
    }
    
    func selectBandwidthButton() {
        onView(withId("resources_bandwidth_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectRamButton() {
        onView(withId("resources_ram_button"))
            .matchesNext(isDisplayed())
            .perform(click())
    }
    
    func selectSellTab() {
        onView(allOf(
            ancestorOf(withId("manage_ram_tabs")),
            withText("Sell")
        )).matchesNext(isDisplayed()).perform(click())
    }
    
    func verifyStakedResources(cpu: String, net: String) {
        onView(withId("resources_scroll_container"))
            .matchesNext(isDisplayed())
            
        if #available(OSX 12, *) {
        } else {
            onView(withId("resources_scroll_container"))
                .perform(scrollToBottom())
        }
        
        onView(allOf(
            withId("cpu_value"),
            ancestorOf(
                allOf(
                    withId("net_cpu_container"),
                    ancestorOf(withId("resources_staked_container"))
                )
            )
        ))
            .matchesNext(isDisplayed())
            .matches(withText(cpu))
        
        onView(allOf(
            withId("net_value"),
            ancestorOf(
                allOf(
                    withId("net_cpu_container"),
                    ancestorOf(withId("resources_staked_container"))
                )
            )
        ))
            .matchesNext(isDisplayed())
            .matches(withText(net))
    }
}
