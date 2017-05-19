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
    case dequeue(orderId: String)
}

// MARK: - TargetType Protocol Implementation
extension WebService: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.myservice.com")! }
    
    var path: String {
        switch self {
        case .queues:
            return "/queue"
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
        case .dequeue(let orderId):
            return ["orderId": orderId]
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
    
    var sampleData: Data {
        switch self {
        default: return "Nothing here".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .queues, .enqueue, .dequeue:
            return .request
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
