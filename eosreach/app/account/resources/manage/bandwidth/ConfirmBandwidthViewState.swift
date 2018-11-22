import Foundation

enum ConfirmBandwidthViewState: MxViewState {
    case idle
    case populate(bandwidthFormBundle: BandwidthFormBundle)
    case onProgress
    case onError
    case withLog(log: String)
    case navigateToTransactionConfirmed(actionReceipt: ActionReceipt)
}
