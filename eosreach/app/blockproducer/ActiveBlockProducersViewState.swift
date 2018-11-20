import Foundation

enum ActiveBlockProducersViewState: MxViewState {
    case idle
    case onProgress
    case onError
    case onSuccess(blockProducerList: [BlockProducerDetails])
    case blockProducerSelected(blockProducer: BlockProducerDetails)
    case blockProducerInformationSelected(blockProducer: BlockProducerDetails)
}
