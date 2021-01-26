//
//  Settings.swift
//  Example
//
//  Created by Anton Belousov on 26.01.2021.
//

import Foundation
import UserDefaultPropertyWrapper

class Settings {
    static let shared = Settings()
    
    @UserDefault("boolValue", defaultValue: false)
    var boolValue: Bool
    
    @UserDefault("intValue", defaultValue: 0)
    var intValue: Int
    
    @UserDefault("doubleValue", defaultValue: 0)
    var doubleValue: Double
    
    @UserDefault("floatValue", defaultValue: 0)
    var floatValue: Float
    
    @UserDefault("stringValue", defaultValue: "")
    var stringValue: String
    
    @UserDefault("optionalStringValue", defaultValue: nil)
    var optionalStringValue: String?
    
    @UserDefault("dateValue", defaultValue: .distantFuture)
    var dateValue: Date
    
    @UserDefault("optionalDataValue", defaultValue: nil)
    var optionalDataValue: Data?
    
    @UserDefault("array", defaultValue: [])
    var array: [[Int]]
    
    @UserDefault("dict", defaultValue: [:])
    var dict: [String: Int]
}

struct User: Codable, UserDefaultsConvertible {
    var firstname: String
    var lastname: String
    var birthdate: Date
    var address: String
}

class UsersSource {
    
    static let defaults = UserDefaults(suiteName: "app.group.id")!
    
    @UserDefault("users", defaultValue:[], defaults: UsersSource.defaults)
    var users: [User]
}

func test() {
    Settings.shared.array = [[1],[2,3]]
    print(Settings.shared.array)

    let user = User(
        firstname: "Artur",
        lastname: "Fleck",
        birthdate: Date(timeIntervalSince1970: -729345600),
        address: "Arkham Asylum, Gotham County, New Jersey, United States of America")
    
    var source = UsersSource()
    source.users.append(user)
    
    source = UsersSource()
    print(source.users)
    
    ActivityStorage().activity = .reading(book: "Hearts of Three")
    print(ActivityStorage().activity ?? "nil")
}

enum Activity: UserDefaultsConvertible {
    var userDefaultsValue: Any {
        switch self {
        case .reading(let book):
            return "r\(book)"
        case .watching(let movie):
            return "w\(movie)"
        }
    }
    
    static func create(from userDefaultsValue: Any) -> Activity {
        var value = userDefaultsValue as! String
        if value.hasPrefix("r") {
            value.removeFirst()
            return .reading(book: value)
        } else if value.hasPrefix("w") {
            value.removeFirst()
            return .watching(movie: value)
        }
        fatalError()
    }
    
    case watching(movie: String)
    case reading(book: String)
}

class ActivityStorage {
    @UserDefault("activity", defaultValue: nil)
    var activity: Activity?
}
