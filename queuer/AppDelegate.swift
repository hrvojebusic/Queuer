//
//  AppDelegate.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationService: NotificationService!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationService = NavigationService()
        navigationService.pushLaunchViewController()
        notificationService = NotificationService(navigationService: navigationService)
        
        window?.rootViewController = navigationService.navigationContainer
        window?.makeKeyAndVisible()
        
        configureNotifications(application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device token for notifications: " + deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Push notification received: \(userInfo)")
        notificationService.handle(userInfo: userInfo)
    }

    
    private func configureNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Approval granted for notification display.")
                application.registerForRemoteNotifications()
            } else {
                print("Error ocurred for during notification authorization:")
                print(error.debugDescription)
            }
        }
    }
}

