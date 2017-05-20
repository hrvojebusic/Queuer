//
//  UIConstants.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation
import UIKit

class UIConstants: NSObject {
    
    // Queues list
    static let navigationBarTintColor = UIColor(red: 5/255, green: 64/255, blue: 123/255, alpha: 1.0)
    static let tableViewBackgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    static let queueNameFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let queueNameColor = UIColor(red: 7/255, green: 66/255, blue: 122/255, alpha: 1.0)
    
    static let describingLabelFont = UIFont.systemFont(ofSize: 12.0)
    static let describingLabelColor = UIColor(red: 183/255, green: 189/255, blue: 194/255, alpha: 1.0)
    
    static let numberLabelFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let numberLabelColor = UIColor(red: 143/255, green: 142/255, blue: 148/255, alpha: 1.0)
    static let estimatedTimeNumberLabelColor = UIColor(red: 7/255, green: 66/255, blue: 122/255, alpha: 1.0)
    
    static let estimatedWaitingTimeLabel = "Vrijeme čekanja"
    static let processingNumberLabel = "Trenutno na redu"
    static let nextInLineNumberLabel = "Sljedeći za izvlačenje"
    
    
    static let pendingCellBackgroundColor = UIColor(red: 7/255, green: 66/255, blue: 122/255, alpha: 1)
    static let defaultCellBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    // MARK:- Ready cell
    static let readyCellBackgroundColor = UIColor(red: 10/255, green: 121/255, blue: 24/255, alpha: 1)
    
    static let readyCellQueueNameFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let readyCellQueueNameColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static let readyCellMessageFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let readyCellMessageColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let readyCellMessageLabel = "Vaš broj je trenutno na redu!"
}
