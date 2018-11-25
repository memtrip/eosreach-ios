import Foundation

protocol DataTableView {
    
    associatedtype tableViewType
    
    func dataTableView() -> tableViewType
}
