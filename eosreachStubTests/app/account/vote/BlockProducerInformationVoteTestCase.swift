import Foundation

class BlockProducerInformationVoteTestCase : StubTestCase {
    
    func testBlockProducerInformationVote() {
        importKeyOrchestra
            .go(privateKey: "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3")
        
        accountRobot.begin { it in
            it.verifyAccountScreen()
            it.verifyAvailableBalance(availableBalance: "$162947.12")
            it.selectVoteTab()
        }
        
        voteRobot.begin { it in
            it.verifyNotVotedScreen()
            it.selectVoteForProducers()
            it.verifyCastProducerVoteScreen()
            it.selectAddBlockProducerFromList()
        }
        
        blockProducerRobot.begin { it in
            it.verifyBlockProducerListScreen()
            it.verifyBlockProducerListFirstAccountRow()
            it.selectBlockProducerListFirstAccountRowInformation()
            it.verifyViewBlockProducerInformationScreen(
                name: "EOS New York",
                website: "https://www.eosnewyork.io",
                email: "community@eosnewyork.io")
            it.selectViewOwnerAccount()
        }
        
        accountRobot.verifyReadOnlyAccountScreen()
    }
}
