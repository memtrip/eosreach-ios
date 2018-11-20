import Foundation

enum ActiveBlockProducersIntent: MxIntent {
    case idle
    case start
    case retry
    case blockProducerSelected(blockProducerDetails: BlockProducerDetails)
    case blockProducerInformationSelected(blockProducerDetails: BlockProducerDetails)
}
