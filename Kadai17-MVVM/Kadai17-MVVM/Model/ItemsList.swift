//
//  ItemsList.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import RxSwift
import RxCocoa

protocol ItemsListModel {
    var itemsObservable: Observable<[Item]> { get }
    func addItem(item: Item)
    func toggle(index: Int)
    func editName(index: Int, name: String)
}

final class ItemsList: ItemsListModel {
    enum Fruits {
        static let apple = "りんご"
        static let orange = "みかん"
        static let banana = "バナナ"
        static let pineapple = "パイナップル"
    }

    private var items: [Item] = [
        Item(isChecked: false, name: Fruits.apple),
        Item(isChecked: true, name: Fruits.orange),
        Item(isChecked: false, name: Fruits.banana),
        Item(isChecked: true, name: Fruits.pineapple)
    ]

    private lazy var itemsRelay = BehaviorRelay<[Item]>(value: items)

    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    func addItem(item: Item) {
        items.append(item)
        itemsRelay.accept(items)
    }

    func toggle(index: Int) {
        items[index].isChecked.toggle()
        itemsRelay.accept(items)
    }

    func editName(index: Int, name: String) {
        items[index].name = name
        itemsRelay.accept(items)
    }
}
