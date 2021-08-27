//
//  InputViewModel.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import RxSwift
import RxCocoa

protocol InputViewModelInput {
    func didTapCancelButton()
    func didTapSaveButton(mode: InputViewController.Mode, nameText: String)
    func editingName(index: Int)
}

protocol InputViewModelOutput {
    var event: Driver<InputViewModel.Event> { get }
}

protocol InputViewModelType {
    var inputs: InputViewModelInput { get }
    var outputs: InputViewModelOutput { get }
}

final class InputViewModel: InputViewModelInput, InputViewModelOutput {
    enum Event {
        case dismiss
        case setName(String)
    }

    private let model: ItemsListModel = ModelLocator.shared.model // modelを共有
    private let eventRelay = PublishRelay<Event>()
    private let disposeBag = DisposeBag()
    private var items: [Item] = []

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

    var event: Driver<Event> {
        return eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func didTapCancelButton() {
        eventRelay.accept(.dismiss)
    }

    func didTapSaveButton(mode: InputViewController.Mode, nameText: String) {
        switch mode {
        case .add:
            let item = Item(isChecked: false, name: nameText)
            model.addItem(item: item)
        case .edit(let index):
            model.editName(index: index, name: nameText)
        }
        eventRelay.accept(.dismiss)
    }

    func editingName(index: Int) {
        let name = items[index].name
        eventRelay.accept(.setName(name))
    }
}

// MARK: - InputViewModelType
extension InputViewModel: InputViewModelType {
    var inputs: InputViewModelInput {
        return self
    }

    var outputs: InputViewModelOutput {
        return self
    }
}
