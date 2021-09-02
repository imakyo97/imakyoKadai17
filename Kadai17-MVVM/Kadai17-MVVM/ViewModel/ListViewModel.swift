//
//  ListViewModel.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import RxSwift
import RxCocoa

protocol ListViewModelInput {
    func didTapAddButton()
    func didSelectRow(index: Int)
    func didTapAccessoryButton(index: Int)
    func didDeleteCell(index: Int)
}

protocol ListViewModelOutput {
    var itemsObservable: Observable<[Item]> { get }
    var event: Driver<ListViewModel.Event> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInput { get }
    var outputs: ListViewModelOutput { get }
}

final class ListViewModel: ListViewModelInput, ListViewModelOutput {
    enum Event {
        case presentAdd
        case presentEdit(Int)
    }

    private let model: ItemsListModel = ModelLocator.shared.model // modelを共有
    private let eventRelay = PublishRelay<Event>()
    private let disposeBag = DisposeBag()

    lazy var itemsObservable: Observable<[Item]> = model.itemsObservable

    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func didTapAddButton() {
        eventRelay.accept(.presentAdd)
    }

    func didSelectRow(index: Int) {
        model.toggle(index: index)
    }

    func didTapAccessoryButton(index: Int) {
        eventRelay.accept(.presentEdit(index))
    }

    func didDeleteCell(index: Int) {
        model.deleteItem(index: index)
    }
}

// MARK: - ListViewModelType
extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {
        return self
    }

    var outputs: ListViewModelOutput {
        return self
    }
}
