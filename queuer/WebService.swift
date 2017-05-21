//
//  WebService.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation
import Moya

enum WebService {
    case queues
    case enqueue(queueId: String)
    case dequeue(queueId: String, ticketNumber: Int)
}

// MARK: - TargetType Protocol Implementation
extension WebService: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.myservice.com")! }
    
    var path: String {
        switch self {
        case .queues:
            return "/queues"
        case .enqueue:
            return "/queue/register"
        case .dequeue:
            return "/queue/cancel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .queues:
            return .get
        case .enqueue, .dequeue:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .queues:
            return nil
        case .enqueue(let queueId):
            return ["queueId": queueId]
        case .dequeue(let queueId, let ticketNumber):
            return ["queueId": queueId, "ticketNumber": ticketNumber]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .queues:
            return URLEncoding.default
        case .enqueue, .dequeue:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .queues, .enqueue, .dequeue:
            return .request
        }
    }
    
    var sampleData: Data {
        switch self {
        case .queues:
            return stubbedResponse("queues")
        case .enqueue(let id):
            if id == "test" {
                return stubbedResponse("qr_scan_success")
            } else {
                return stubbedResponse("qr_scan_failure")
            }
        case .dequeue:
            return stubbedResponse("ticket_invalidated_success")
        }
    }
}

// MARK: - Helpers
private extension String {
    
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

extension WebService {
    
    func stubbedResponse(_ fileName: String) -> Data {
        let path = Bundle.main.url(forResource: fileName, withExtension: "json")
        return try! Data(contentsOf: path!)
    }
}
