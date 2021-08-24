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

    private let viewModel: ListViewModelType = ListViewModel()
    private let disposeBag = DisposeBag()
    private let dataSource = ItemDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        viewModel.inputs.loadList()
    }

    private func setupBinding() {
        viewModel.outputs.items
            .bind(to: itemTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        itemTableView.register(
            ItemTableViewCell.nib,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
    }
}
