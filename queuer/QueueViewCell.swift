//
//  QueueViewCell.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit

class QueueViewCell: UITableViewCell {

    @IBOutlet var queueName: UILabel!
    
    @IBOutlet var estimatedLabel: UILabel!
    @IBOutlet var estimatedNumber: UILabel!
    
    @IBOutlet var currentNoLabel: UILabel!
    @IBOutlet var currentNoNumber: UILabel!
    
    @IBOutlet var dynamicNoLabel: UILabel!
    @IBOutlet var dynamicNoNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        queueName.font = UIConstants.queueNameFont
        queueName.textColor = UIConstants.queueNameColor
        
        estimatedLabel.font = UIConstants.describingLabelFont
        estimatedLabel.textColor = UIConstants.describingLabelColor
        estimatedLabel.text = UIConstants.estimatedWaitingTimeLabel
        
        estimatedNumber.font = UIConstants.numberLabelFont
        estimatedNumber.textColor = UIConstants.estimatedTimeNumberLabelColor
        
        currentNoLabel.font = UIConstants.describingLabelFont
        currentNoLabel.textColor = UIConstants.describingLabelColor
        currentNoLabel.text = UIConstants.processingNumberLabel
        
        currentNoNumber.font = UIConstants.numberLabelFont
        currentNoNumber.textColor = UIConstants.numberLabelColor
        
        dynamicNoLabel.font = UIConstants.describingLabelFont
        dynamicNoLabel.textColor = UIConstants.describingLabelColor
        dynamicNoLabel.text = UIConstants.nextInLineNumberLabel
        
        dynamicNoNumber.font = UIConstants.numberLabelFont
        dynamicNoNumber.textColor = UIConstants.numberLabelColor
    }
    
    func setup(withModel viewModel: QueueViewModel) {
        queueName.text = viewModel.name
        estimatedNumber.text = "Nesto ovdje"
        currentNoNumber.text = "\(viewModel.processingTicketNumber)"
        dynamicNoNumber.text = "\(viewModel.lastTicketNumber)"
    }
}
