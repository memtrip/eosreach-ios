import Foundation
import Material
import RxCocoa

class ReachTextField : TextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = R.color.colorAccent()
        textColor = R.color.typographyColorPrimary()
        placeholderNormalColor = R.color.typographyColorPlaceholder()!
        dividerNormalColor = R.color.colorAccent()!
        placeholderActiveColor = R.color.colorAccent()!
        dividerActiveColor = R.color.colorAccent()!
    }
}

class ReachUsernameTextField : ReachTextField {
    
    let usernameFilter = UsernameFilter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        if let last = sender.text?.last {
            if (!usernameFilter.check(string: String(last), textField: sender)) {
                sender.text?.removeLast()
            }
        }
    }
}

class ReachBalanceTextField : ReachTextField {
    
    let balanceFilter = BalanceFilter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        if let last = sender.text?.last {
            if (!balanceFilter.check(string: String(last), textField: sender)) {
                sender.text?.removeLast()
            }
        }
    }
}

class UsernameFilter {
    
    let regex = try! NSRegularExpression(pattern: "^[A-Za-z1-5]+$", options: .caseInsensitive)
    
    func check(string: String, textField: UITextField) -> Bool {
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        let patternMatched = matches.count > 0
        let count = (textField.text == nil) ? 0 : textField.text!.count
        return (patternMatched && count <= 12) || string.isEmpty
    }
}

class BalanceFilter {
    
    func check(string: String, textField: UITextField) -> Bool {
        if textField.text != "" || string != "" {
            let value = (textField.text ?? "")
            return Double(value) != nil
        }
        return false
    }
}
