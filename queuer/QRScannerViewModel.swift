//
//  QRScannerViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/21/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation
import RxSwift
import RxFeedback
import Moya

enum QRScannerEvent {
    case scan(String)
    case scanning
    case scanned(QueueViewModel)
    case error(Swift.Error)
}

enum ScanResult {
    case scanning
    case scanned(QueueViewModel)
    case error(Swift.Error)
    
    var isScanning: Bool {
        if case .scanning = self {
            return true
        }
        return false
    }
    
    var isScanned: Bool {
        if case .scanned = self {
            return true
        }
        return false
    }
}

struct QRScannerState {
    var shouldScan: Bool
    var request: String?
    var result: ScanResult?
}

class QRScannerViewModel {
    
    let processing: Observable<Bool>
    let codeApproved: Observable<Void>
    let processResult: Observable<QueueViewModel?>
    
    init(scanRequest: PublishSubject<String>, provider: RxMoyaProvider<WebService>) {
        let scanEventLoop: (Observable<QRScannerState>) -> Observable<QRScannerEvent> = { _ -> Observable<QRScannerEvent> in
            return scanRequest.map { QRScannerEvent.scan($0) }
        }
        
        let system = Observable.system(initialState: QRScannerState.init(shouldScan: false, request: nil, result: nil), reduce: { state, event -> QRScannerState in
            var newState = state
            newState.shouldScan = false
            switch event {
            case .scan(let request):
                newState.shouldScan = true
                newState.request = request
            case .scanning:
                newState.result = .scanning
            case .scanned(let viewModel):
                newState.result = .scanned(viewModel)
            case .error(let error):
                newState.result = .error(error)
            }
            return newState
        }, scheduler: MainScheduler.instance, feedback: { state -> Observable<QRScannerEvent> in
            return state.filter { $0.shouldScan }.flatMapLatest { state -> Observable<QRScannerEvent> in
                return provider.request(.enqueue(queueId: state.request!)).mapJSONDictionary()
                    .map { try QueueViewModel(dic: $0) }
                    .map { QRScannerEvent.scanned($0) }
                    .startWith(QRScannerEvent.scanning)
                    .catchError { Observable.just(QRScannerEvent.error($0)) }
                    .observeOn(MainScheduler.instance)
            }
        }, scanEventLoop).shareReplay(1)
        
        processing = system.map { $0.result?.isScanning ?? false }
        processResult = system.map { state in
            guard let result = state.result else {
                return nil
            }
            
            switch result{
            case .scanned(let model):
                return model
            default:
                return nil
            }
        }
        codeApproved = system.filter { $0.result?.isScanned ?? false }.map { _ in return }
    }
}
