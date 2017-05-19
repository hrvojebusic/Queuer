//
//  Dictionary+Extensions.swift
//  queuer
//
//  Created by Shoutem on 5/19/17.
//  Copyright © 2017 Hrvoje. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [JSONDictionary]

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    
    // MARK: String
    public func string(_ key: Key) -> String? {
        return self[key] as? String
    }
    
    public func string(key: Key, orThrow: Error) throws -> String {
        guard let val = string(key) else { throw orThrow }
        return val
    }
    
    public func stringOrThrow(key: Key) throws -> String {
        return try valueOrThrow(key)
    }
    
    // MARK: Double
    public func double(_ key: Key) -> Double? {
        return self[key] as? Double
    }
    
    public func doubleOrThrow(key: Key) throws -> Double {
        return try valueOrThrow(key)
    }
    
    // MARK: Int
    public func int(key: Key) -> Int? {
        return self[key] as? Int
    }
    
    public func intOrThrow(key: Key) throws -> Int {
        return try valueOrThrow(key)
    }
    
    // Mark: Bool
    public func bool(_ key: Key) -> Bool? {
        return self[key] as? Bool
    }
    
    public func bool(key: Key, or defaultValue: Bool) -> Bool {
        return bool(key) ?? defaultValue
    }
    
    public func boolOrThrow(key: Key) throws -> Bool {
        return try valueOrThrow(key)
    }
    
    // MARK: Json
    public func jsonArray(key: Key) -> JSONArray? {
        return self[key] as? JSONArray
    }
    
    public func jsonArrayOrThrow(key: Key) throws -> JSONArray {
        return try valueOrThrow(key)
    }
    
    public func jsonDictionary(key: Key) -> JSONDictionary? {
        return self[key] as? JSONDictionary
    }
    
    public func jsonDictionaryOrThrow(key: Key) throws -> JSONDictionary {
        return try valueOrThrow(key)
    }
    
    // MARK: Misc
    public func stringOrDoubleAsString(key: Key) -> String? {
        if let str = string(key) { return str }
        if let double = double(key) { return String(double) }
        
        return nil
    }
    
    public func anyAsString(key: Key) -> String? {
        if let val = self[key] {
            return "\(val)"
        }
        return nil
    }
    
    // MARK: Generic
    public func valueOrThrow<T>(_ key: Key) throws -> T {
        guard let val = self[key] as? T else {
            throw genericKeyErrorFor(key)
        }
        return val
    }
}

func genericKeyErrorFor<T: ExpressibleByStringLiteral>(_ key: T) -> Error {
    return NSError(domain: "Dictionary", code: -1, userInfo: [
        NSLocalizedDescriptionKey: "Dictionary doesn't contain key: \"\(key)\" of type \(T.self)"
        ])
}
