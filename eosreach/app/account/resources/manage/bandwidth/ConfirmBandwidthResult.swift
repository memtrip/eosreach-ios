import Foundation

enum ConfirmBandwidthResult: MxResult {
    case idle
    case populate(bandwidthFormBundle: BandwidthFormBundle)
    case onProgress
    case onError
    case withLog(log: String)
    case navigateToTransactionConfirmed(transactionId: String)
}
