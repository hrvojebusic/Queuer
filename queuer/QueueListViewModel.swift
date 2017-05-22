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
    case downloaded(RoomViewModel)
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
    var cache: RoomViewModel?
    var result: DownloadResult<RoomViewModel>?
}

class QueuesViewModel {

    // Outputs
    let room: Observable<RoomViewModel>
    let contentUpdating: Observable<Bool>
    let contentUpdated: Observable<Void>
    
    init(downloadContentSignal: PublishSubject<Void>, provider: RxMoyaProvider<WebService>) {
        let downloadEventLoop: (Observable<QueueListState>) -> Observable<QueueListEvent> = { _ -> Observable<QueueListEvent> in
            return downloadContentSignal.asObserver().map { QueueListEvent.download }
        }

        let system = Observable.system(initialState: QueueListState(shouldDownload: false, cache: nil, result: nil), reduce: { state, event -> QueueListState in
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
                return provider.request(.queues).mapJSONDictionary()
                    .map { QueuesViewModel.mapRoomModel(dictionary: $0) }
                    .map { QueueListEvent.downloaded($0) }
                    .startWith(QueueListEvent.downloading)
                    .catchError({ (error) -> Observable<QueueListEvent> in
                        return Observable.just(QueueListEvent.error(error))
                    }).observeOn(MainScheduler.instance)
                })
        }, downloadEventLoop).shareReplay(1)

        self.room = system.map { $0.cache }.filter { $0 != nil }.map { $0! }
        self.contentUpdating = system.map { $0.result?.isDownloading == true }
        self.contentUpdated = system.filter { $0.result?.isDownloaded == true }.map { _ in return () }
    }

    private static func mapRoomModel(dictionary: JSONDictionary) -> RoomViewModel {
        let roomName = dictionary.string("name")!
        let room = RoomViewModel(name: roomName)
        var queues: [QueueViewModel] = []
        
        for dic in dictionary.jsonArray(key: "queues")! {
            do {
                queues.append(try QueueViewModel(dic: dic))
            } catch {
                print("Error occurred during JSON parsing.")
            }
        }
        
        room.queues = queues
        return room
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
