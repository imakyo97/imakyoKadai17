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
    private let itemsRelay = PublishRelay<[Item]>()
    private let eventRelay = PublishRelay<Event>()
    private var items: [Item] = []
    private let disposeBag = DisposeBag()

    init() {
        setupBinding()
    }

    private func setupBinding() {
        model.itemsObservable
            .subscribe(onNext: { [weak self] items in
                self?.items = items
            })
            .disposed(by: disposeBag)
    }

    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    func loadList() {
        itemsRelay.accept(items)
    }

    func didTapAddButton() {
        eventRelay.accept(.presentInputVC(.add, nil))
    }

    func didTapItem(index: Int) {
        model.toggle(index: index)
        itemsRelay.accept(items)
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
