//
//  TicketViewController.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TicketViewController: UIViewController {
    
    @IBOutlet var currentNoLabel: UILabel!
    @IBOutlet var currentNoNumber: UILabel!
    @IBOutlet var ticketNoLabel: UILabel!
    @IBOutlet var ticketNoNumber: UILabel!
    @IBOutlet var smallDescriptiveText: UILabel!
    @IBOutlet var largeDescriptiveText: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    // Input
    var viewModel: QueueViewModel!
    
    // Output
    let ticketCanceled = PublishSubject<QueueViewModel>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIConstants.navigationBarTintColor
    }
    
    private func setupView() {
        appearanceSetup()
        leadingTextSetup()
        ticketSetup()
        trailingTextSetup()
        cancelButtonSetup()
    }
    
    private func appearanceSetup() {
        navigationItem.title = viewModel.queueName
        
        switch viewModel.ticketState {
        case .waiting:
            view.backgroundColor = UIConstants.waitingTicketBackgroundColor
            navigationController?.navigationBar.barTintColor = UIConstants.waitingTicketBackgroundColor
            break
        case .ready:
            view.backgroundColor = UIConstants.readyTicketBackgroundColor
            navigationController?.navigationBar.barTintColor = UIConstants.readyTicketBackgroundColor
            break
        case .canceled:
            view.backgroundColor = UIConstants.canceledTicketBackgroundColor
            navigationController?.navigationBar.barTintColor = UIConstants.canceledTicketBackgroundColor
            break
        default:
            break
        }
    }
    
    private func leadingTextSetup() {
        if viewModel.ticketState != .waiting {
            currentNoLabel.isHidden = true
            currentNoNumber.isHidden = true
            return
        }
        
        currentNoLabel.font = UIConstants.supportiveLabelFont
        currentNoLabel.textColor = UIConstants.supportiveLabelColor
        currentNoLabel.text = UIConstants.processingNoLabel
        currentNoLabel.isHidden = false
        
        currentNoNumber.font = UIConstants.mainLabelFont
        currentNoNumber.textColor = UIConstants.mainLabelColor
        currentNoNumber.text = "\(viewModel.processingTicketNumber)"
        currentNoNumber.isHidden = false
    }
    
    private func ticketSetup() {
        ticketNoLabel.font = UIConstants.ticketNoLabelFont
        ticketNoLabel.textColor = UIConstants.ticketNoLabelColor
        ticketNoLabel.text = UIConstants.ticketNoLabelText
        
        ticketNoNumber.font = UIConstants.ticketNoNumberFont
        ticketNoNumber.textColor = UIConstants.ticketNoNumberColor
        ticketNoNumber.text = "\(viewModel.takenTicketNumber!)"
    }
    
    private func trailingTextSetup() {
        largeDescriptiveText.font = UIConstants.mainLabelFont
        largeDescriptiveText.textColor = UIConstants.mainLabelColor
        
        if viewModel.ticketState == .waiting {
            largeDescriptiveText.text = "\(viewModel.timeEstimate)"
            smallDescriptiveText.font = UIConstants.supportiveLabelFont
            smallDescriptiveText.textColor = UIConstants.supportiveLabelColor
            smallDescriptiveText.text = UIConstants.estimatedTimeLabel
            smallDescriptiveText.isHidden = false
        } else {
            if viewModel.ticketState == .ready {
                largeDescriptiveText.text = UIConstants.readyTicketDescription
            } else {
                largeDescriptiveText.text = UIConstants.canceledTicketDescription
            }
            smallDescriptiveText.isHidden = true
        }
    }
    
    private func cancelButtonSetup() {
        if viewModel.ticketState == .canceled {
            cancelButton.isHidden = true
            return
        }
        
        cancelButton.titleLabel?.font = UIConstants.actionButtonFont
        cancelButton.titleLabel?.textColor = UIConstants.actionButtonColor
        cancelButton.setTitle(UIConstants.cancelButtonLabel, for: .normal)
        cancelButton.isHidden = false
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let sSelf = self else {
                return
            }
            sSelf.ticketCanceled.onNext(sSelf.viewModel)
        }).disposed(by: disposeBag)
    }
}
