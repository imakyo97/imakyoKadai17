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
    func didTapSaveButton()
    var nameTextRelay: PublishRelay<String> { get }
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
        case reload
    }

    private let model: ItemsListModel = ModelLocator.share.model
    private let eventRelay = PublishRelay<Event>()
    private let disposeBag = DisposeBag()
    private var nameText: String = ""

    init() {
        setupBinding()
    }

    private func setupBinding() {
        nameTextRelay
            .bind(onNext: { [weak self] nameText in
                self?.nameText = nameText
            })
            .disposed(by: disposeBag)
    }

    var nameTextRelay = PublishRelay<String>()

    var event: Driver<Event> {
        return eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func didTapCancelButton() {
        eventRelay.accept(.dismiss)
    }

    func didTapSaveButton() {
        let item = Item(isChecked: false, name: nameText)
        model.addItem(item: item)
        eventRelay.accept(.dismiss)
        eventRelay.accept(.reload)
    }
}

extension InputViewModel: InputViewModelType {
    var inputs: InputViewModelInput {
        return self
    }

    var outputs: InputViewModelOutput {
        return self
    }
}
