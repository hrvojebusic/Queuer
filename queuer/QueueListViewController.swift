//
//  QueueListViewController.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxDataSources

class QueuesViewController: UIViewController {
    
    // Inputs
    var viewModel: QueuesViewModel!
    
    // Outputs
    let viewDidLoadSignal = PublishSubject<Void>()
    let pullToRefreshSignal = PublishSubject<Void>()
    let queueSelectedSignal = PublishSubject<QueueViewModel>()
    
    private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewDidLoadSignal.onNext(())
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = UIConstants.tableViewBackgroundColor
        
        let standardCellString = String(describing: StandardTableViewCell.self)
        let standardCellNib = UINib(nibName: standardCellString, bundle: nil)
        tableView.register(standardCellNib, forCellReuseIdentifier: "StandardCell")
        
        let readyCellString = String(describing: ReadyTableViewCell.self)
        let readyCellNib = UINib(nibName: readyCellString, bundle: nil)
        tableView.register(readyCellNib, forCellReuseIdentifier: "ReadyCell")
        
        let dataSource = RxTableViewSectionedReloadDataSource<QueueListSection>()
        dataSource.configureCell = { (_, tv, _, item) -> UITableViewCell in
            if item.ticketState != .ready {
                let cell = tv.dequeueReusableCell(withIdentifier: "StandardCell") as! StandardTableViewCell
                cell.setup(withModel: item)
                return cell
            } else {
                let cell = tv.dequeueReusableCell(withIdentifier: "ReadyCell") as! ReadyTableViewCell
                cell.setup(withModel: item)
                return cell
            }
        }
        
        tableView.rx.modelSelected(QueueViewModel.self).asObservable().subscribe(onNext: { model in
            self.queueSelectedSignal.onNext(model)
        }).disposed(by: disposeBag)
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIConstants.tableViewBackgroundColor
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: pullToRefreshSignal)
            .disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
        
        viewModel.contentUpdating.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        viewModel.queues.map { [QueueListSection(items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        view.addSubview(tableView)
    }
}
