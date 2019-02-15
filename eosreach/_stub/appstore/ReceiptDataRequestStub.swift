import Foundation
import RxSwift

class ReceiptDataRequestStub : ReceiptDataRequest {
    
    func retrieveReceipt() -> Single<String> {
        return Single.create { single in
            do {
                fatalError("not implemented")
            } catch {
                single(.error(NoReceiptError()))
            }
            return Disposables.create()
        }
    }
}
