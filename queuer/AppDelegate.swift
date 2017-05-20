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
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationContainerViewController = NavigationContainerViewController()
        navigationContainerViewController.pushLaunchViewController()
        
        window?.rootViewController = navigationContainerViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

