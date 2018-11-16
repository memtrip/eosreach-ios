import Foundation
import UIKit

class SimpleTableViewCell<T> : UITableViewCell {

    func populate(item: T) {
        fatalError("populate must be implemented")
    }
}
