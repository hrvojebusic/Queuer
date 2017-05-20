//
//  SectionOfData.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation
import RxDataSources

typealias Item = QueueViewModel

struct QueueListSection {
    var items: [Item]
}

extension QueueListSection: SectionModelType {
    
    init(original: QueueListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
