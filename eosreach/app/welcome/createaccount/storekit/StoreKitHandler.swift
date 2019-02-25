import Foundation
import StoreKit

protocol Billing {
    func startConnection()
    func endConnection()
    func pay(product: SKProduct)
}

class BillingImpl : Billing {
    
    let storeKitRequest: StoreKitRequest
    
    let billingFlowDelegate: BillingFlowDelegate
    
    init(storeKitHandler: StoreKitHandler, billingFlowDelegate: BillingFlowDelegate) {
        self.storeKitRequest = StoreKitRequestFactory.create(storeKitHandler: storeKitHandler)
        self.billingFlowDelegate = billingFlowDelegate
    }
    
    func startConnection() {
        storeKitRequest.start()
    }
    
    func endConnection() {
        storeKitRequest.cancel()
    }
    
    func pay(product: SKProduct) {
        storeKitRequest.pay(product: product)
    }
}

class StoreKitHandler : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let billingConnectionDelegate: BillingConnectionDelegate
    let billingFlowDelegate: BillingFlowDelegate
    
    init (
        billingConnectionDelegate: BillingConnectionDelegate,
        billingFlowDelegate: BillingFlowDelegate
    ) {
        self.billingConnectionDelegate = billingConnectionDelegate
        self.billingFlowDelegate = billingFlowDelegate
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            DispatchQueue.main.async {
                self.billingConnectionDelegate.success(skProduct: response.products[0])
            }
        } else {
            DispatchQueue.main.async {
                self.billingConnectionDelegate.storekitError()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                self.billingFlowDelegate.purchasing()
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate.success(transactionIdentifier: transaction.transactionIdentifier!)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate.failed()
            case .restored:
                break
            case .deferred:
                self.billingFlowDelegate.failed()
                break
            }
        }
    }
}

protocol BillingConnectionDelegate {
    func success(skProduct: SKProduct)
    func storekitError()
}

protocol BillingFlowDelegate {
    func cannotMakePayment()
    func purchasing()
    func success(transactionIdentifier: String)
    func failed()
}
