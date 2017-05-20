//
//  QueuesWrapper.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

class QueuesWrapper {
    
    let name: String
    let queues: [JSONDictionary]
    
    init(dictionary: JSONDictionary) throws {
        name = try dictionary.stringOrThrow(key: "name")
        queues = try dictionary.jsonArrayOrThrow(key: "queues")
    }
}
