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
import RxDataSources

class QueuesViewController: UIViewController {
    
    // Outputs
    let viewDidLoadSignal = PublishSubject<Void>()
    let pullToRefreshSignal = PublishSubject<Void>()
    let queueSelectedSignal = PublishSubject<String>()
    
    var viewModel: QueueListViewModel!
    
    private let disposeBag = DisposeBag()

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
        viewDidLoadSignal.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        setupTableView()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIConstants.navigationBarTintColor
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.frame = view.frame
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 169
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = UIConstants.tableViewBackgroundColor
        
        var cellString = String(describing: QueueViewCell.self)
        var cellNib = UINib(nibName: cellString, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "StandardCell")
        
        cellString = String(describing: ReadyTableViewCell.self)
        cellNib = UINib(nibName: cellString, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ReadyCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: pullToRefreshSignal)
            .disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
        
        let dataSource = RxTableViewSectionedReloadDataSource<QueueListSection>()
        dataSource.configureCell = { (ds, tv, ip, item) -> UITableViewCell in
            let isReady = item.processingTicketNumber == item.orderId
            if isReady {
                let cell = tv.dequeueReusableCell(withIdentifier: "ReadyCell") as! ReadyTableViewCell
                cell.setup(withModel: item)
                return cell
            } else {
                let cell = tv.dequeueReusableCell(withIdentifier: "StandardCell") as! QueueViewCell
                cell.setup(withModel: item)
                return cell
            }
        }
        
        tableView.rx.modelSelected(QueueViewModel.self)
            .asDriver()
            .throttle(0.5)
            .drive(onNext: { [weak self] model in
                self?.queueSelectedSignal.onNext(model.name)
            }).disposed(by: disposeBag)
        
        viewModel.showSpinner.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        viewModel.queues.map { [QueueListSection(items: $0)] }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        view.addSubview(tableView)
    }
    
    func present() {
        let vc = QRScannerController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
}
