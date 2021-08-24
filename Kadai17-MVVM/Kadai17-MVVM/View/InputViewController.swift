//
//  InputViewController.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol InputViewControllerDelegate: AnyObject {
    func didTapSaveButton()
}

class InputViewController: UIViewController {

    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: UITextField!

    weak var delegate: InputViewControllerDelegate?

    private let viewModel: InputViewModelType = InputViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        saveBarButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.didTapSaveButton()
            })
            .disposed(by: disposeBag)

        cancelBarButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.didTapCancelButton()
            })
            .disposed(by: disposeBag)

        nameTextField.rx.text
            .bind(onNext: { [weak self] nameText in
                guard let nameText = nameText else { return }
                self?.viewModel.inputs.nameTextRelay.accept(nameText)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                case .dismiss:
                    self?.dismiss(animated: true, completion: nil)
                case .reload:
                    self?.delegate?.didTapSaveButton()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension InputViewController {
    static func instantiate() -> InputViewController {
        UIStoryboard(name: "Input", bundle: nil)
            .instantiateInitialViewController()
            as! InputViewController
    }
}
