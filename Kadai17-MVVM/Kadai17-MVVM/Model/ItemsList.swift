//
//  ItemsList.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import RxSwift
import RxRelay

protocol ItemsListModel {
    var itemsObservable: Observable<[Item]> { get }
    func addItem(item: Item)
    func toggle(index: Int)
    func editName(index: Int, name: String)
    func deleteItem(index: Int)
}

final class ItemsList: ItemsListModel {
    enum Fruits {
        static let apple = "りんご"
        static let orange = "みかん"
        static let banana = "バナナ"
        static let pineapple = "パイナップル"
    }
    
    // 状態の二重管理を避けるため、itemsRelayに一本化しました
    private lazy var itemsRelay = BehaviorRelay<[Item]>(
        value: [
            Item(isChecked: false, name: Fruits.apple),
            Item(isChecked: true, name: Fruits.orange),
            Item(isChecked: false, name: Fruits.banana),
            Item(isChecked: true, name: Fruits.pineapple)
        ]
    )
    
    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }
    
    func addItem(item: Item) {
        var items = itemsRelay.value
        items.append(item)
        itemsRelay.accept(items)
    }
    
    func toggle(index: Int) {
        var items = itemsRelay.value
        items[index].isChecked.toggle()
        itemsRelay.accept(items)
    }
    
    func editName(index: Int, name: String) {
        var items = itemsRelay.value
        items[index].name = name
        itemsRelay.accept(items)
    }
    
    func deleteItem(index: Int) {
        var items = itemsRelay.value
        items.remove(at: index)
        itemsRelay.accept(items)
    }
}
