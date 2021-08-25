//
//  ListViewController.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    @IBOutlet private weak var itemTableView: UITableView!
    @IBOutlet private weak var addBarButton: UIBarButtonItem!

    private let viewModel: ListViewModelType = ListViewModel()
    private let disposeBag = DisposeBag()
    private let dataSource = ItemDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTableView()
    }

    private func setupBinding() {
        addBarButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.didTapAddButton()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.itemsObservable
            .bind(to: itemTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                case .presentInputVC(let mode, let index):
                    let inputViewController = InputViewController.instantiate(mode: mode, editingItemIndex: index)
                    let navigationController = UINavigationController(rootViewController: inputViewController)
                    self?.present(navigationController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        itemTableView.register(
            ItemTableViewCell.nib,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        itemTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.didTapItem(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        viewModel.inputs.didTapaccessoryButton(index: indexPath.row)
    }
}
