//
//  QueueViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

enum TicketState {
    case notTaken
    case waiting
    case ready
    case canceled
}

class QueueViewModel {
    
    var ticketState: TicketState
    var queueName: String
    var processingTicketNumber: Int
    var lastTicketNumber: Int
    var timeEstimate: Int
    var takenTicketNumber: Int?
    
    var ticketObtained: Bool {
        return ticketState != .notTaken
    }
    
    init(dic: JSONDictionary) throws {
        queueName = try dic.stringOrThrow(key: "name")
        processingTicketNumber = try dic.intOrThrow(key: "processingTicketNumber")
        lastTicketNumber = try dic.intOrThrow(key: "lastTicketNumber")
        timeEstimate = try dic.intOrThrow(key: "timeEstimate")
        takenTicketNumber = dic.int(key: "ticketNumber")
        
        if let order = takenTicketNumber {
            if order == processingTicketNumber {
                ticketState = .ready
            } else if order > processingTicketNumber {
                ticketState = .waiting
            } else {
                ticketState = .canceled
            }
        } else {
            ticketState = .notTaken
        }
    }
    
    func userCanceledTicket() {
        ticketState = .notTaken
        takenTicketNumber = nil
    }
}
