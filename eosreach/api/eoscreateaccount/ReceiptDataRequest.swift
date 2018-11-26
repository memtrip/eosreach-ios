import Foundation
import RxSwift

class ReceiptDataRequest {
    
    func retrieveReceipt() -> Single<String> {
        return Single.create { single in
            do {
                if let receiptUrl = Bundle.main.appStoreReceiptURL {
                    let receiptData = try Data(contentsOf: receiptUrl, options: .alwaysMapped)
                    let receiptString = receiptData.base64EncodedString(options: [])
                    single(.success(receiptString))
                } else {
                    single(.error(NoReceiptError()))
                }
            } catch {
                single(.error(NoReceiptError()))
            }
            return Disposables.create()
        }
    }
}

class NoReceiptError : Error {
}
