//
//  AppDelegate.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let viewController = QueuesViewController()
        let provider = RxMoyaProvider<WebService>.init(stubClosure: MoyaProvider.delayedStub(1))
        let viewModel = QueueListViewModel(viewLoaded: viewController.viewDidLoadSignal, pullToRefresh: viewController.pullToRefreshSignal, provider: provider)
        viewController.viewModel = viewModel

        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()

        return true
    }
}

