//
//  QueueViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

class QueueViewModel {
    
    let name: String
    let processingTicketNumber: Int
    let lastTicketNumber: Int
    let timeEstimate: Int?
    let orderId: Int?
    
    init(dic: JSONDictionary) throws {
        name = try dic.stringOrThrow(key: "name")
        processingTicketNumber = try dic.intOrThrow(key: "processingTicketNumber")
        lastTicketNumber = try dic.intOrThrow(key: "lastTicketNumber")
        timeEstimate = dic.int(key: "timeEstimate")
        orderId = dic.int(key: "orderId")
    }
}
