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
        case edit(Int)
    }

    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: UITextField!

    private let viewModel: InputViewModelType = InputViewModel()
    private let disposeBag = DisposeBag()
    private let mode: Mode

    init?(coder: NSCoder, mode: Mode) {
        self.mode = mode
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupMode()
    }

    private func setupMode() {
        switch mode {
        case .add:
            break
        case .edit(let editingItemIndex):
            viewModel.inputs.editingName(index: editingItemIndex)
        }
    }

    private func setupBinding() {
        saveBarButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let nameText = self?.nameTextField.text else { return }
                guard nameText != "" else { return }
                self?.viewModel.inputs.didTapSaveButton(
                    mode: self!.mode,
                    nameText: nameText
                )
            })
            .disposed(by: disposeBag)

        cancelBarButton.rx.tap
            .subscribe(onNext: viewModel.inputs.didTapCancelButton)
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                case .dismiss:
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.name
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension InputViewController {
    static func instantiate(mode: Mode) -> InputViewController {
        UIStoryboard(name: "Input", bundle: nil)
            .instantiateInitialViewController(creator: { coder in
                InputViewController(coder: coder, mode: mode)
            })!
    }
}
