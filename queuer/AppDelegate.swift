//
//  AppDelegate.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import UserNotifications
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationService = NavigationService()
        navigationService.pushLaunchViewController()
        
        window?.rootViewController = navigationService.navigationContainer
        window?.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting{
            case .enabled:
                
                print("enabled sound setting")
                
            case .disabled:
                
                print("setting has been disabled")
                
            case .notSupported:
                print("something vital went wrong here")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
}

