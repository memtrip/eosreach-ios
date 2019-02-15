import Foundation
import StoreKit

protocol Billing {
    
    func startConnection(
        billingConnectionDelegate: BillingConnectionDelegate,
        billingFlowDelegate: BillingFlowDelegate)
    
    func pay(product: SKProduct)
}

class BillingImpl : Billing {
    
    let storeKitHandler: StoreKitHandler
    let productsRequest = SKProductsRequest(productIdentifiers:
        NSSet(object: R.string.appStrings.app_create_account_product_id()) as! Set<String>)
    
    var billingConnectionDelegate: BillingConnectionDelegate?
    var billingFlowDelegate: BillingFlowDelegate?
    
    init(storeKitHandler: StoreKitHandler) {
        self.storeKitHandler = storeKitHandler
    }
    
    func startConnection(
        billingConnectionDelegate: BillingConnectionDelegate,
        billingFlowDelegate: BillingFlowDelegate
    ) {
        self.billingConnectionDelegate = billingConnectionDelegate
        self.billingFlowDelegate = billingFlowDelegate
        self.storeKitHandler.setup(billingConnectionDelegate: billingConnectionDelegate, billingFlowDelegate: billingFlowDelegate)
        
        productsRequest.delegate = storeKitHandler
        productsRequest.start()
    }
    
    func endConnection() {
        productsRequest.cancel()
    }
    
    func pay(product: SKProduct)  {
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().add(storeKitHandler)
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            self.billingFlowDelegate!.cannotMakePayment()
        }
    }
}

class StoreKitHandler : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var billingConnectionDelegate: BillingConnectionDelegate?
    var billingFlowDelegate: BillingFlowDelegate?
    
    func setup(
        billingConnectionDelegate: BillingConnectionDelegate,
        billingFlowDelegate: BillingFlowDelegate
    ) {
        self.billingConnectionDelegate = billingConnectionDelegate
        self.billingFlowDelegate = billingFlowDelegate
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            DispatchQueue.main.async {
                self.billingConnectionDelegate!.success(skProduct: response.products[0])
            }
        } else {
            DispatchQueue.main.async {
                self.billingConnectionDelegate!.skuNotFound()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                self.billingFlowDelegate!.purchasing()
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate!.success(transactionIdentifier: transaction.transactionIdentifier!)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.billingFlowDelegate!.failed()
            case .restored:
                break
            case .deferred:
                break // TODO: hmm?
            }
        }
    }
}

protocol BillingConnectionDelegate {
    func success(skProduct: SKProduct)
    func skuNotFound()
    func skuBillingUnavailable()
    func skuRequestFailed()
    func billingSetupFailed()
}

protocol BillingFlowDelegate {
    func cannotMakePayment()
    func purchasing()
    func success(transactionIdentifier: String)
    func failed()
    func deferred()
}
