//
//  NavigationContainerViewController.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import RxSwift
import Moya

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
    
    func pushInitial(_ launchViewController: UIViewController) {
        currentNavigationController = UINavigationController(navigationBarClass: QueuesNavigationBar.self, toolbarClass: nil)
        push(launchViewController, animated: false)
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
        currentNavigationController.dismiss(animated: true, completion: nil)
        let navigationController = UINavigationController(navigationBarClass: QueuesNavigationBar.self, toolbarClass: nil)
        navigationController.addChildViewController(viewController)
        currentNavigationController.present(navigationController, animated: animated, completion: nil)
    }
    
    func dissmis(_ animated: Bool) {
        currentNavigationController.dismiss(animated: animated, completion: nil)
    }
    
    func showActivity(_ show: Bool) {
        var view = currentNavigationController.view
        if let modal = currentNavigationController.topViewController?.presentedViewController, !modal.isKind(of: UIAlertController.self) {
            view = modal.view
        }
        if let view = view {
            if (show) {
                ProgressView.shared.showProgressView(view)
            } else {
                ProgressView.shared.hideProgressView()
            }
        }
        currentNavigationController.interactivePopGestureRecognizer?.isEnabled = !show
    }
}
