import UIKit

typealias Res = R

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIView {

    func visible() {
        if (self is ReachActivityIndicator) {
            fatalError("For instances of `ReachActivityIndicator`, use the start() extension")
        }
        isHidden = false
    }

    func gone() {
        if (self is ReachActivityIndicator) {
            fatalError("For instances of `ReachActivityIndicator`, use the stop() extension")
        }
        isHidden = true
    }
    
    func goneCollapsed() {
        isHidden = true
        addConstraint(NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.height,
            multiplier: 1,
            constant: 0
        ))
    }
}

extension UIViewController {
    
    func showOKDialog(message: String) {
        self.showOKDialog(
            title: R.string.appStrings.app_error_view_title(),
            message: message)
    }
    
    func showOKDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.appStrings.app_dialog_ok(), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showViewLog(viewLogHandler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(
            title: R.string.appStrings.app_dialog_view_log_title(),
            message: R.string.appStrings.app_dialog_view_log_body(),
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.appStrings.app_dialog_view_log_positive_button(), style: .default, handler: viewLogHandler))
        alert.addAction(UIAlertAction(title: R.string.appStrings.app_dialog_view_log_negative_button(), style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    func setToolbar(toolbar: ReachToolbar) {
        toolbar.backMenuButton.addTarget(self, action: #selector(handleBackMenu(button:)), for: .touchUpInside)
    }

    @objc func handleBackMenu(button: UIButton) {
        self.close()
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func replaceChildViewController(viewController: UIViewController, containerView: UIView) {
        
        if let existingViewControllerId = children.firstIndex(where: { vc in
            vc.nibName == viewController.nibName
        }) {
            children[existingViewControllerId].removeFromParent()
            containerView.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    func replaceChildViewController(viewController: UIViewController) {
        fatalError()
    }
    
    func showTransactionReceipt(
        actionReceipt: ActionReceipt,
        contractAccountBalance: ContractAccountBalance,
        delegate: TransactionReceiptDelegate
    ) {
        let transactionReceiptViewController = TransactionReceiptViewController(nib: R.nib.transactionReceiptViewController)
        transactionReceiptViewController.transactionReceiptBundle = TransactionReceiptBundle(
            actionReceipt: actionReceipt,
            contractAccountBalance: contractAccountBalance,
            transactionReceiptRoute: TransactionReceiptRoute.account_resources)
        transactionReceiptViewController.delegate = delegate
        self.present(transactionReceiptViewController, animated: true, completion: nil)
    }
    
    func showTransactionLog(log: String) {
        let transactionLogViewController = TransactionLogViewController(nib: R.nib.transactionLogViewController)
        transactionLogViewController.errorLog = log
        self.present(transactionLogViewController, animated: true, completion: nil)
    }
}
