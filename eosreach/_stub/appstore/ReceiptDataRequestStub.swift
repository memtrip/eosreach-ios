import Foundation
import RxSwift

class ReceiptDataRequestStub : ReceiptDataRequest {
    
    func retrieveReceipt() -> Single<String> {
        return Single.create { single in
            switch StoreKitStubStateHolder.shared.state {
            case .success:
                single(.success("VGhlIHdoZWVsIHB1dCB0aGUgZ2lhbnRzIG91dCBvZiBidXNpbmVzcw"))
            case .cannotMakePayment:
                fatalError("Impossible path, critical test failure.")
            }
            return Disposables.create()
        }
    }
}
