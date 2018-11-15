import Foundation

extension Date {

    func fullDateTime() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEE dd MMM HH:mm:ss"
        return dateFormatterPrint.string(from: self)
    }
}
