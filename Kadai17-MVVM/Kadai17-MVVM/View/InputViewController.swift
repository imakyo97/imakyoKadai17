//
//  InputViewController.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class InputViewController: UIViewController {
    enum Mode {
        case add
        case edit
    }

    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: UITextField!

    private let viewModel: InputViewModelType = InputViewModel()
    private let disposeBag = DisposeBag()
    private let mode: Mode
    private let editingItemIndex: Int?

    init?(coder: NSCoder, mode: Mode, editingItemIndex: Int?) {
        self.mode = mode
        if let index = editingItemIndex {
            self.editingItemIndex = index
        } else {
            self.editingItemIndex = nil
        }
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupMode()
    }

    private func setupMode() {
        guard mode == .edit else { return }
        viewModel.inputs.editingName(index: editingItemIndex!)
    }

    private func setupBinding() {
        saveBarButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let nameText = self?.nameTextField.text else { return }
                guard nameText != "" else { return }
                self?.viewModel.inputs.didTapSaveButton(
                    mode: self!.mode,
                    nameText: nameText,
                    index: self?.editingItemIndex
                )
            })
            .disposed(by: disposeBag)

        cancelBarButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.didTapCancelButton()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                case .dismiss:
                    self?.dismiss(animated: true, completion: nil)
                case .setName(let name):
                    self?.nameTextField.text = name
                }
            })
            .disposed(by: disposeBag)
    }
}

extension InputViewController {
    static func instantiate(mode: Mode, editingItemIndex: Int?) -> InputViewController {
        UIStoryboard(name: "Input", bundle: nil)
            .instantiateInitialViewController(creator: { coder in
                InputViewController(coder: coder, mode: mode, editingItemIndex: editingItemIndex)
            })!
    }
}
