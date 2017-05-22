//
//  NavigationService.swift
//  queuer
//
//  Created by Shoutem on 5/20/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import RxSwift
import Moya

class NavigationService {
    
    let provider = RxMoyaProvider<WebService>(stubClosure: MoyaProvider.delayedStub(1))
    let updateContentSignal = PublishSubject<Void>()
    
    let navigationContainer = NavigationContainerViewController()
    let disposeBag = DisposeBag()
    
    func pushLaunchViewController() {
        let launchViewController = QueuesViewController()
        launchViewController.viewModel = QueuesViewModel(downloadContentSignal: updateContentSignal, provider: provider)
        
        PublishSubject.merge(launchViewController.viewDidLoadSignal,
                             launchViewController.pullToRefreshSignal)
            .subscribe(onNext: { self.updateContentSignal.onNext(()) })
            .disposed(by: disposeBag)
        
        launchViewController.queueSelectedSignal.subscribe(onNext: { model in
            if model.ticketObtained {
                self.presentTicketViewController(withModel: model)
            } else {
                self.presentQRScannerViewController(withModel: model)
            }
        }).disposed(by: disposeBag)
        
        navigationContainer.pushInitial(launchViewController)
    }
    
    func presentQRScannerViewController(withModel model: QueueViewModel) {
        let qrScannerViewController = QRScannerViewController()
        let qrScannerViewModel = QRScannerViewModel(scanRequest: qrScannerViewController.codeScanned, provider: provider)
        qrScannerViewController.viewModel = qrScannerViewModel
        
        qrScannerViewController.scannerDismised.subscribe(onNext: {
            self.navigationContainer.dissmis(true)
        }).disposed(by: disposeBag)
        
        qrScannerViewModel.processResult.filter { $0 != nil }.subscribe(onNext: { model in
            let timeDelay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: timeDelay) {
                self.navigationContainer.dissmis(true)
                self.presentTicketViewController(withModel: model!)
            }
        }).disposed(by: disposeBag)
        
        navigationContainer.present(qrScannerViewController, animated: true)
    }
    
    func presentTicketViewController(withModel model: QueueViewModel, fromNotification: Bool = false) {
        let ticketViewController = TicketViewController()
        ticketViewController.viewModel = model
        
        ticketViewController.ticketCanceled.flatMap { model -> Observable<QueueViewModel> in
            self.navigationContainer.showActivity(true)
            return self.provider
                .request(.dequeue(queueId: model.queueName, ticketNumber: model.takenTicketNumber!))
                .mapJSONDictionary().map { try QueueViewModel(dic: $0) }
            }.subscribe(onNext: { _ in
                let timeDelay = DispatchTime.now() + 0.5
                self.updateContentSignal.onNext(())
                DispatchQueue.main.asyncAfter(deadline: timeDelay) {
                    self.navigationContainer.showActivity(false)
                    self.navigationContainer.popViewController(true)
                }
            }, onError: { _ in
                let timeDelay = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: timeDelay) {
                    self.navigationContainer.showActivity(false)
                }
            }).disposed(by: disposeBag)
        
        navigationContainer.push(ticketViewController, animated: true, byReplacingTheStack: fromNotification)
    }
}
