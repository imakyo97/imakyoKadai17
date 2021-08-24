//
//  ListViewModel.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import RxSwift
import RxCocoa

protocol ListViewModelInput {
    func loadList()
}

protocol ListViewModelOutput {
    var items: Observable<[Item]> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInput { get }
    var outputs: ListViewModelOutput { get }
}

final class ListViewModel: ListViewModelInput, ListViewModelOutput {

    private let model: ItemsListModel = ItemsList()
    private let itemsRelay = PublishRelay<[Item]>()

    var items: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    func loadList() {
        itemsRelay.accept(model.items)
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {
        return self
    }

    var outputs: ListViewModelOutput {
        return self
    }
}
