import UIKit
import RxSwift
import RxCocoa
import Material

class TransactionLogViewController: UIViewController {

    @IBOutlet weak var toolBar: ReachToolbar!
    @IBOutlet weak var logTextView: UITextView!
    
    var errorLog: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(toolbar: toolBar)
        view.backgroundColor = R.color.colorWindowBackground()
        toolBar.title = R.string.transactionStrings.transaction_view_log_title()
        logTextView.text = errorLog!
    }
}
