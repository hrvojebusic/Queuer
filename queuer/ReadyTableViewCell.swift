//
//  ReadyTableViewCell.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit

class ReadyTableViewCell: UITableViewCell {

    @IBOutlet var chevronIcon: UIImageView!
    @IBOutlet var queueNameLabel: UILabel!
    @IBOutlet var ticketReadyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = UIConstants.readyCellBackgroundColor
        
        chevronIcon.image = UIImage(named: "WhiteChevron")
        
        queueNameLabel.font = UIConstants.readyCellQueueNameFont
        queueNameLabel.textColor = UIConstants.readyCellQueueNameColor
        
        ticketReadyLabel.font = UIConstants.readyCellMessageFont
        ticketReadyLabel.textColor = UIConstants.readyCellMessageColor
        ticketReadyLabel.text = UIConstants.readyCellMessageLabel
    }
    
    func setup(withModel model: QueueViewModel) {
        queueNameLabel.text = model.queueName
    }
}
