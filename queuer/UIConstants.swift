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
    
    // System wide
    static let supportiveLabelColor = UIColor(red: 183/255, green: 189/255, blue: 194/255, alpha: 1.0)
    static let supportiveLabelFont = UIFont.systemFont(ofSize: 12.0)
    
    static let mainLabelColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let mainLabelFont = UIFont.boldSystemFont(ofSize: 24.0)
    
    static let actionButtonColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let actionButtonFont = UIFont.boldSystemFont(ofSize: 16.0)
    
    static let navigationBarTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let navigationBarBarTintColor = UIColor(red: 10/255, green: 67/255, blue: 121/255, alpha: 1.0)
    
    static let navigationItemTitleColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let navigationItemTitleFont = UIFont.boldSystemFont(ofSize: 16.0)
    
    static let cameraOverlayColor = UIColor(red: 10/255, green: 67/255, blue: 121/255, alpha: 1.0)
    
    // Queues list
    static let tableViewBackgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    
    static let queueNameFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let queueNameIdleColor = UIColor(red: 7/255, green: 66/255, blue: 122/255, alpha: 1.0)
    static let queueNamePendingColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static let numberLabelFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let numberLabelIdleColor = UIColor(red: 143/255, green: 142/255, blue: 148/255, alpha: 1.0)
    static let estimatedNumberLabelIdleColor = UIColor(red: 7/255, green: 66/255, blue: 122/255, alpha: 1.0)
    static let numberLabelPendingColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static let estimatedWaitingTimeLabel = "Vrijeme čekanja"
    static let processingNumberLabel = "Trenutno na redu"
    static let nextInLineNumberLabel = "Sljedeći za izvlačenje"
    static let takenNumberLabel = "Vaš broj"
    
    // MARK: Standard cell
    static let standardIdleCellBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let standardPendingCellBackgroundColor = UIColor(red: 10/255, green: 67/255, blue: 121/255, alpha: 1.0)
    
    // MARK:- Ready cell
    static let readyCellBackgroundColor = UIColor(red: 10/255, green: 121/255, blue: 24/255, alpha: 1)
    
    static let readyCellQueueNameFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let readyCellQueueNameColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static let readyCellMessageFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let readyCellMessageColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let readyCellMessageLabel = "Vaš broj je trenutno na redu!"
    
    // MARK:- Ticket
    static let ticketNoLabelColor = UIColor(red: 183/255, green: 189/255, blue: 194/255, alpha: 1.0)
    static let ticketNoLabelFont = UIFont.systemFont(ofSize: 24.0)
    static let ticketNoLabelText = "Vaš broj"
    
    static let ticketNoNumberColor = UIColor.black
    static let ticketNoNumberFont = UIFont.boldSystemFont(ofSize: 72.0)
    
    // MARK:- Ticket waiting
    static let waitingTicketBackgroundColor = UIColor(red: 10/255, green: 67/255, blue: 121/255, alpha: 1.0)
    static let processingNoLabel = "Treuntno na redu"
    static let estimatedTimeLabel = "Vrijeme čekanja"
    static let cancelButtonLabel = "Otkaži"
    
    // MARK:- Ticket ready
    static let readyTicketBackgroundColor = UIColor(red: 28/255, green: 120/255, blue: 30/255, alpha: 1.0)
    static let readyTicketDescription = "Vaš zahtjev je sada na redu za obradu"
    
    // MARK:- Ticket canceled
    static let canceledTicketBackgroundColor = UIColor(red: 233/255, green: 27/255, blue: 35/255, alpha: 1.0)
    static let canceledTicketDescription = "Propustili ste mjesto u redu"
    
    // MARK:- QR scanner
    static let qrScannerTitle = "Skenirajte kod"
    
    static let qrScannerDescriptionLabelFont = UIFont.boldSystemFont(ofSize: 16.0)
    static let qrScannerDescriptionLabelColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let qrScannerDescriptionLabelText = "Skenirajte QR kod na ekranu redomata u prostoriji"
    
    static let qrScannerSuccessMessageLabelFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let qrScannerSuccessMessageLabelColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
    static let qrScannerSuccessMessageLabelText = "QR kod očitan!"
    
    static let qrScannerYellowBorder = UIColor(red: 241/255, green: 208/255, blue: 33/255, alpha: 1.0)
    static let qrScannerGreenBorder = UIColor(red: 10/255, green: 121/255, blue: 24/255, alpha: 1.0)
}
