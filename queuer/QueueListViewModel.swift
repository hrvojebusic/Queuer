//
//  QueueListViewModel.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation
import RxSwift
import RxFeedback
import Moya

enum QueueListEvent {
    case download
    case downloading
    case error(Swift.Error)
    case downloaded([QueueViewModel])
}

enum DownloadResult<T> {
    case downloading
    case downloaded(T)
    case error(Swift.Error)

    var isDownloading: Bool {
        if case .downloading = self {
            return true
        }
        return false
    }
    
    var isDownloaded: Bool {
        if case .downloaded = self {
            return true
        }
        return false
    }
}

struct QueueListState {
    var shouldDownload: Bool
    var cache: [QueueViewModel]?
    var result: DownloadResult<[QueueViewModel]>?
}

class QueueListViewModel {

    // Outputs
    let queues: Observable<[QueueViewModel]>
    let showSpinner: Observable<Bool>
    let contentUpdated: Observable<Void>
    
    init(viewLoaded: Observable<Void>, pullToRefresh: Observable<Void>, provider: RxMoyaProvider<WebService>) {
        let timer = Observable<Int>.interval(10, scheduler: MainScheduler.instance)

        let downloadEventLoop: (Observable<QueueListState>) -> Observable<QueueListEvent> = { _ -> Observable<QueueListEvent> in
            return Observable.merge(viewLoaded, pullToRefresh.debug("Pull to refresh"), timer.map { _ in () }).map { QueueListEvent.download }
        }

        let system = Observable.system(initialState: QueueListState.init(shouldDownload: false, cache: nil, result: nil), reduce: { state, event -> QueueListState in
            var newState = state
            newState.shouldDownload = false
            switch event {
            case .download:
                newState.shouldDownload = true
            case .downloading:
                newState.result = .downloading
            case .downloaded(let viewModels):
                newState.cache = viewModels
                newState.result = .downloaded(viewModels)
            case .error(let error):
                newState.result = .error(error)
            }
            return newState
        }, scheduler: MainScheduler.instance, feedback: { state -> Observable<QueueListEvent> in
            return state.filter { $0.shouldDownload }.flatMapLatest({ (_) -> Observable<QueueListEvent> in
                return provider.request(.queues).mapJSONArray()
                    .map { QueueListViewModel.mapViewModels(dictionaries: $0) }
                    .map { QueueListEvent.downloaded($0) }
                    .startWith(QueueListEvent.downloading)
                    .catchError({ (error) -> Observable<QueueListEvent> in
                        return Observable.just(QueueListEvent.error(error))
                    }).observeOn(MainScheduler.instance)
            })
        }, downloadEventLoop).shareReplay(1)

        self.queues = system.debug("Prolazim").map { $0.cache }.filter { $0 != nil }.map { $0! }
        self.showSpinner = system.map { $0.result?.isDownloading == true }
        self.contentUpdated = system.filter { $0.result?.isDownloaded == true }.map { _ in return () }
    }

    private static func mapViewModels(dictionaries: [JSONDictionary]) -> [QueueViewModel] {
        var models: [QueueViewModel] = []
        for dictionary in dictionaries {
            do {
                models.append(try QueueViewModel(dic: dictionary))
            } catch {
                print("Error occurred during JSON parsing.")
            }
        }
        return models
    }
}

extension ObservableType where E == Response {
    
    func mapJSONDictionary() -> Observable<JSONDictionary> {
        return mapJSON().map({ (any) -> JSONDictionary in
            guard let any = any as? JSONDictionary else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            return any
        })
    }
    
    func mapJSONArray() -> Observable<[JSONDictionary]> {
        return mapJSON().map({ (any) -> [JSONDictionary] in
            guard let any2 = any as? JSONDictionary else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            
            guard let any3 = any2.jsonArray(key: "queues") else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            return any3
        })
    }
}
