//
//  StandardTableViewCell.swift
//  queuer
//
//  Created by Shoutem on 5/21/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit

class StandardTableViewCell: UITableViewCell {

    @IBOutlet var chevronIcon: UIImageView!
    @IBOutlet var queueName: UILabel!
    @IBOutlet var estimatedTimeLabel: UILabel!
    @IBOutlet var estimatedTimeNumber: UILabel!
    @IBOutlet var currentNoLabel: UILabel!
    @IBOutlet var currentNoNumber: UILabel!
    @IBOutlet var dynamicNoLabel: UILabel!
    @IBOutlet var dynamicNoNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        queueName.font = UIConstants.queueNameFont
        
        estimatedTimeLabel.font = UIConstants.supportiveLabelFont
        estimatedTimeLabel.textColor = UIConstants.supportiveLabelColor
        estimatedTimeLabel.text = UIConstants.estimatedWaitingTimeLabel
        
        estimatedTimeNumber.font = UIConstants.numberLabelFont
        
        currentNoLabel.font = UIConstants.supportiveLabelFont
        currentNoLabel.textColor = UIConstants.supportiveLabelColor
        currentNoLabel.text = UIConstants.processingNumberLabel
        
        currentNoNumber.font = UIConstants.numberLabelFont
        
        dynamicNoLabel.font = UIConstants.supportiveLabelFont
        dynamicNoLabel.textColor = UIConstants.supportiveLabelColor
        
        dynamicNoNumber.font = UIConstants.numberLabelFont
    }

    func setup(withModel viewModel: QueueViewModel) {
        queueName.text = viewModel.queueName
        estimatedTimeNumber.text = "\(viewModel.timeEstimate)"
        currentNoNumber.text = "\(viewModel.processingTicketNumber)"
        
        if viewModel.ticketState == .notTaken {
            backgroundColor = UIConstants.standardIdleCellBackgroundColor
            chevronIcon.image = UIImage(named: "GreyChevron")
            
            queueName.textColor = UIConstants.queueNameIdleColor
            estimatedTimeNumber.textColor = UIConstants.estimatedNumberLabelIdleColor
            currentNoNumber.textColor = UIConstants.numberLabelIdleColor
            dynamicNoLabel.text = UIConstants.nextInLineNumberLabel
            dynamicNoNumber.text = "\(viewModel.lastTicketNumber)"
            dynamicNoNumber.textColor = UIConstants.numberLabelIdleColor
            
        } else {
            backgroundColor = UIConstants.standardPendingCellBackgroundColor
            chevronIcon.image = UIImage(named: "WhiteChevron")
            
            queueName.textColor = UIConstants.queueNamePendingColor
            estimatedTimeNumber.textColor = UIConstants.numberLabelPendingColor
            currentNoNumber.textColor = UIConstants.numberLabelPendingColor
            dynamicNoLabel.text = UIConstants.takenNumberLabel
            dynamicNoNumber.text = "\(viewModel.takenTicketNumber!)"
            dynamicNoNumber.textColor = UIConstants.numberLabelPendingColor
        }
    }
}
