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

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
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
                let inputViewController = InputViewController.instantiate(
                    mode: InputViewController.Mode(event: event)
                )

                let navigationController = UINavigationController(rootViewController: inputViewController)
                self?.present(navigationController, animated: true, completion: nil)
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

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.didSelectRow(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        viewModel.inputs.didTapAccessoryButton(index: indexPath.row)
    }
}

// MARK: - ItemDataSourceDelegate
// 自作delegate
extension ListViewController: ItemDataSourceDelegate {

    // cellの削除を通知するメソッド
    func didDeleteCell(indexRow: Int) {
        viewModel.inputs.didDeleteCell(index: indexRow)
    }
}

private extension InputViewController.Mode {
    init(event: ListViewModel.Event) {
        switch event {
        case .presentAdd:
            self = .add
        case .presentEdit(let index):
            self = .edit(index)
        }
    }
}
