//
//  QueuesViewController.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class QueuesViewController: UIViewController {
    
    // Outputs
    let viewDidLoadSignal = PublishSubject<Void>()
    let pullToRefreshSignal = PublishSubject<Void>()
    
    var viewModel: QueueListViewModel!
    
    private let disposeBag = DisposeBag()

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        viewDidLoadSignal.onNext(())
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(QueueViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.frame = self.view.frame
        view.addSubview(tableView)
        
        let refreshControl = UIRefreshControl()

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: pullToRefreshSignal)
            .disposed(by: disposeBag)

        viewModel.showSpinner.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
        
        viewModel.queues.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: QueueViewCell.self)) {(_, model, cell) in
            cell.update(model: model)
        }.disposed(by: disposeBag)
    }
}
