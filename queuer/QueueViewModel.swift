//
//  QueueViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

class QueueViewModel {
    
    let current: Int
    let nextPublished: Int
    let timeEstimate: Int
    let orderId: Int?
    
    init(dic: JSONDictionary) throws {
        current = try dic.intOrThrow(key: "current")
        nextPublished = try dic.intOrThrow(key: "nextPublished")
        timeEstimate = try dic.intOrThrow(key: "timeEstimate")
        orderId = dic.int(key: "orderId")
    }
}
