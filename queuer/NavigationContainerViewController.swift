//
//  NavigationContainerViewController.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class NavigationContainerViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    var currentNavigationController: UINavigationController! {
        didSet {
            if let oldValue = oldValue,  oldValue == currentNavigationController {
                return
            }
            
            if let previousNavigationController = oldValue {
                previousNavigationController.willMove(toParentViewController: nil)
                previousNavigationController.view.removeFromSuperview()
                previousNavigationController.removeFromParentViewController()
            }
            
            guard let navigationController = currentNavigationController else { return }
            addChildViewController(navigationController)
            view.addSubview(navigationController.view)
            navigationController.didMove(toParentViewController: self)
        }
    }
    
    func push(_ viewController: UIViewController, inNavigationController navigationController: UINavigationController? = nil, animated: Bool, byReplacingTheStack: Bool = false) {
        let nvc = navigationController ?? currentNavigationController
        if byReplacingTheStack {
            guard let rootVC = nvc?.viewControllers.first else {
                nvc?.pushViewController(viewController, animated: animated)
                return
            }
            nvc?.setViewControllers([rootVC, viewController], animated: animated)
        } else {
            nvc?.pushViewController(viewController, animated: animated)
        }
    }
    
    func popViewController(_ animated: Bool) {
        _ = currentNavigationController?.popViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        let navigationController = UINavigationController(rootViewController: viewController)
        currentNavigationController.present(navigationController, animated: animated, completion: nil)
    }
    
    func dissmis(_ animated: Bool) {
        currentNavigationController.dismiss(animated: animated, completion: nil)
    }
    
    func pushLaunchViewController() {
        let launchViewController = QueuesViewController()
        let provider = RxMoyaProvider<WebService>.init(stubClosure: MoyaProvider.delayedStub(1))
        let viewModel = QueueListViewModel(viewLoaded: launchViewController.viewDidLoadSignal, pullToRefresh: launchViewController.pullToRefreshSignal, provider: provider)
        launchViewController.viewModel = viewModel
        launchViewController.queueSelectedSignal.subscribe(onNext: { [weak self] string in
            self?.presentQRScannerViewController()
        }).disposed(by: disposeBag)
        
        let navController = UINavigationController()
        navController.pushViewController(launchViewController, animated: false)
        currentNavigationController = navController
    }
    
    func presentQRScannerViewController() {
        let qrScannerViewController = QRScannerController()
        qrScannerViewController.objectScanned.take(1)
            .subscribe(onNext: { [weak self ]_ in
                self?.dissmis(true)
            })
            .disposed(by: disposeBag)
        
        present(qrScannerViewController, animated: true)
    }
}
