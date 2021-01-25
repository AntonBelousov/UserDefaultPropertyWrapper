//
//  UserDefaultPropertyWrapper.swift
//  
//
//  Created by Anton Belousov on 25.01.2021.
//

import Foundation

// MARK: - UserDefault
@propertyWrapper
public struct UserDefault<T: UserDefaultsConvertible> {
    public let key: String
    public let defaultValue: T
    public let defaults: UserDefaults
    
    public init(_ key: String, defaultValue: T, setupDefault: Bool = false, defaults: UserDefaults = UserDefaults.standard) {
        
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
        if setupDefault && defaults.object(forKey: key) == nil {
            wrappedValue = defaultValue
        }
    }
    
    public var wrappedValue: T {
        get {
            guard let value = defaults.object(forKey: key) else {
                return defaultValue
            }
            return T.create(from: value) as T
        }
        set {
            let value = newValue.userDefaultsValue
            if let value = value as? AnyOptional, value.isNone {
                defaults.set(nil, forKey: key)
            } else {
                defaults.set(value, forKey: key)
            }
        }
    }
}

protocol AnyOptional {
    var isNone: Bool { get }
}

extension Optional: AnyOptional {
    var isNone: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}

// MARK: - UserDefaultsConvertible
public protocol UserDefaultsConvertible {
    var userDefaultsValue: Any { get }
    static func create(from userDefaultsValue: Any) -> Self
}

// MARK: - Swift Primitives
public protocol TollFreeUserDefaultsConvertible: UserDefaultsConvertible {}
extension TollFreeUserDefaultsConvertible {
    public var userDefaultsValue: Any { self }
    public static func create(from userDefaultsValue: Any) -> Self {
        return userDefaultsValue as! Self
    }
}

extension Bool: TollFreeUserDefaultsConvertible {}
extension String: TollFreeUserDefaultsConvertible {}
extension Int: TollFreeUserDefaultsConvertible {}
extension Float: TollFreeUserDefaultsConvertible {}
extension Double: TollFreeUserDefaultsConvertible {}
extension Data: TollFreeUserDefaultsConvertible {}
extension Date: TollFreeUserDefaultsConvertible {}

// MARK: - Array
extension Array: UserDefaultsConvertible where Element: UserDefaultsConvertible {
    public static func create(from userDefaultsValue: Any) -> Self {
        (userDefaultsValue as! [Any]).map{ Element.create(from: $0) }
    }
    
    public var userDefaultsValue: Any {
        map{
            $0.userDefaultsValue
        }
    }
}

// MARK: - Dict
extension Dictionary: UserDefaultsConvertible where Key == String, Value: UserDefaultsConvertible {
    
    public static func create(from userDefaultsValue: Any) -> Self {
        (userDefaultsValue as! [String: Any]).mapValues{ Value.create(from: $0) }
    }
    
    public var userDefaultsValue: Any {
        mapValues{ $0.userDefaultsValue }
    }
}

// MARK: - Optional
extension Optional: UserDefaultsConvertible where Wrapped: UserDefaultsConvertible {
    public var userDefaultsValue: Any {
        switch self {
        case .none:
            return self as Any
        case .some(let value):
            return value.userDefaultsValue
        }
    }
    
    public static func create(from userDefaultsValue: Any) -> Self {
        Wrapped.create(from: userDefaultsValue)
    }
}

// MARK: - UserDefaultsConvertible + Codable
extension UserDefaultsConvertible where Self: Codable {
    var userDefaultsValue: Any {
        return try! PropertyListEncoder().encode(self)
    }
    
    static func create(from userDefaultsValue: Any) -> Self {
        try! PropertyListDecoder().decode(Self.self, from: userDefaultsValue as! Data)
    }
}
