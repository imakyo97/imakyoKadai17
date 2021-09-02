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
    
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: UITextField!
    
    private let viewModel: InputViewModelType
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, mode: InputViewModel.Mode) {
        // modeをInputViewModelで管理する
        self.viewModel = InputViewModel(mode: mode)
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
        switch viewModel.outputs.mode {
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
        
        // テキストフィールドの更新はEventではなく専用のDriverで行うようにしました
        viewModel.outputs.name
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension InputViewController {
    static func instantiate(mode: InputViewModel.Mode) -> InputViewController {
        UIStoryboard(name: "Input", bundle: nil)
            .instantiateInitialViewController(creator: { coder in
                InputViewController(coder: coder, mode: mode)
            })!
    }
}
