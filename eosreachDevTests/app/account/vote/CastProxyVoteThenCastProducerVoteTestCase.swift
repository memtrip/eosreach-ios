import Foundation
@testable import dev

class CastProducerVoteTestCase : DevTestCase {
    
    func testCastProxyVoteThenCastProducerVote() {
        
        importKeyOrchestra
            .go(privateKey: Config.PRIVATE_KEY)
        
        //
        // Proxy vote
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.selectVoteTab()
        }
        
        voteRobot.begin { it in
            it.selectVoteForProxy()
            it.typeCastProxyVote(proxyName: "memtripproxy")
        }
        
        voteRobot.begin { it in
            it.verifyProxyVoteScreen()
        }
        
        accountRobot.verifyAccountScreen()
        
        //
        // Producer vote
        voteRobot.begin { it in
            it.selectVoteForProducers()
            it.verifyCastProducerVoteScreen()
            it.selectAddBlockProducerRow()
            it.typeVoteBlockProducerRow(position: 0, value: "memtripblock")
            it.selectVoteBlockProducerButton()
        }
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
        }
        
        voteRobot.begin { it in
            it.verifyVotedSingleBlockProducersScreen(value: "memtripblock")
        }
    }
}
