//
//  NotificationService.swift
//  queuer
//
//  Created by Shoutem on 5/22/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

class NotificationService {
    
    let navigationService: NavigationService
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
    }
    
    func handle(userInfo: [AnyHashable : Any]) {
        
        guard let type = userInfo["type"] as? String else {
            print("Could not determine app type.")
            return
        }
        
        if type == "ticket" {
            ticketNotification(userInfo: userInfo)
        }
    }
    
    private func ticketNotification(userInfo: [AnyHashable : Any]) {
        guard let apsSection = userInfo["aps"] as? JSONDictionary else {
            print("Could not access app notification parameters.")
            return
        }
        
        guard let queue = apsSection.jsonDictionary(key: "queue") else {
            print("Could not access queue information.")
            return
        }
        
        do {
            let model = try QueueViewModel(dic: queue)
            navigationService.presentTicketViewController(withModel: model, fromNotification: true)
        } catch {
            print("Failed to parse queue from notification")
        }
    }
}
