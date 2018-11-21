import Foundation
import UIKit
import RxCocoa

class SimpleTableView<T, C: SimpleTableViewCell<T>> : UITableView, UITableViewDelegate, UITableViewDataSource {

    var data = [T]()
    var atEnd = false
    var cellBackgroundColor: UIColor?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.delegate = self
        self.dataSource = self

        self.register(cellNib(), forCellReuseIdentifier: cellId())

        self.estimatedRowHeight = 200
        self.rowHeight = UITableView.automaticDimension
        self.backgroundColor = R.color.colorWindowBackground()
    }

    open func cellNib() -> UINib {
        fatalError("nibName() must be overriden")
    }

    open func cellId() -> String {
        fatalError("cellId() must be overriden")
    }

    open func createCell(tableView: UITableView, indexPath: IndexPath) -> C {
        fatalError("createCell() must be overidden in concrete implementations of PinyinListTableView")
    }

    open func bindCell(cell: C, item: T) -> C {
        cell.populate(item: item)
        return cell
    }

    func populate(data: [T]) {
        self.data.append(contentsOf: data)
        self.reloadData()
    }

    func clear() {
        self.data.removeAll()
        self.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createCell(tableView: tableView, indexPath: indexPath)

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let color = cellBackgroundColor {
            cell.contentView.backgroundColor = color
        }
        
        return bindCell(
            cell: cell,
            item: data[indexPath.row]
        )
    }
    
    var atBottom: ControlEvent<T> {
        let source = rx.methodInvoked(#selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))).filter { event in
            let indexPath = event[2] as! IndexPath
            return indexPath.row + 1 == self.data.count && !self.atEnd
        }.map { a -> T in
            let indexPath = a[2] as! IndexPath
            return self.data[indexPath.row]
        }
        
        return ControlEvent(events: source)
    }
    
    var selected: ControlEvent<T> {
        let source = rx.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:))).map { event -> T in
            let indexPath = event[1] as! IndexPath
            return self.data[indexPath.row]
        }
        
        return ControlEvent(events: source)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
