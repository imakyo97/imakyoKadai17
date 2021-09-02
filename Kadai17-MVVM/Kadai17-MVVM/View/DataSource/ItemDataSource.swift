//
//  ItemDataSource.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol ItemDataSourceDelegate: AnyObject {
    
    // cellの削除を通知するメソッド
    func didDeleteCell(indexRow: Int)
}

final class ItemDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [Item]
    var items: Element = []
    
    weak var delegate: ItemDataSourceDelegate?
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemTableViewCell.identifier)
            as! ItemTableViewCell // swiftlint:disable:this force_cast
        cell.configure(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // cellの変更を許可する
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.didDeleteCell(indexRow: indexPath.row)
        }
    }
    
    // MARK: - RxTableViewDataSourceType
    func tableView(_ tableView: UITableView, observedEvent: Event<[Item]>) {
        Binder(self) { dataSource, element in
            dataSource.items = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}
