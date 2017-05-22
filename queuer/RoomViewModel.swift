//
//  RoomViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/22/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

class RoomViewModel {
    
    var name: String
    var queues: [QueueViewModel]?
    
    init(name: String) {
        self.name = name
    }
}
