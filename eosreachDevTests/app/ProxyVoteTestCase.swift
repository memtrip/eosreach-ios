import Foundation
@testable import dev

class ProxyVoteTestCase : DevTestCase {
    
    func testProxyVote() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectVoteTab()
        }
        
        voteRobot.begin { it in
            it.selectVoteForProxy()
            it.verifyCastProxyVoteScreen()
            it.typeCastProxyVote(proxyName: "memtripproxy")
        }
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
        }
        
        voteRobot.begin { it in
            it.verifyProxyVoteScreen()
        }
    }
}
