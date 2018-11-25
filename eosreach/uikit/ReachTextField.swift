import Foundation
import Material

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

class ReachUsernameTextField : ReachTextField, UITextFieldDelegate {
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z1-5]+$", options: .caseInsensitive)
        let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        let patternMatched = matches.count > 0
        let count = (textField.text == nil) ? 0 : textField.text!.count
        return (patternMatched && count < 12) || string.isEmpty
    }
}
