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
    func didTapItem(index: Int)
    func didTapaccessoryButton(index: Int)
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
        case presentInputVC(InputViewController.Mode, Int?)
    }

    private let model: ItemsListModel = ModelLocator.share.model
    private let eventRelay = PublishRelay<Event>()
    private let disposeBag = DisposeBag()

    lazy var itemsObservable: Observable<[Item]> = model.itemsObservable

    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func didTapAddButton() {
        eventRelay.accept(.presentInputVC(.add, nil))
    }

    func didTapItem(index: Int) {
        model.toggle(index: index)
    }

    func didTapaccessoryButton(index: Int) {
        eventRelay.accept(.presentInputVC(.edit, index))
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
