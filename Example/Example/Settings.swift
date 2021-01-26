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
    
    @UserDefault("boolValue")
    var boolValue: Bool

    @UserDefault("boolValueWithDefaultValue", defaultValue: true)
    var boolValueWithDefaultValue: Bool
    
    @UserDefault("intValue")
    var intValue: Int

    @UserDefault("intValueWithDefaultValue", defaultValue: 451)
    var intValueWithDefaultValue: Int
    
    @UserDefault("doubleValue")
    var doubleValue: Double
    
    @UserDefault("floatValue")
    var floatValue: Float
    
    @UserDefault("stringValue", defaultValue: "")
    var stringValue: String
    
    @UserDefault("optionalStringValue")
    var optionalStringValue: String?
    
    @UserDefault("dateValue", defaultValue: .distantFuture)
    var dateValue: Date
    
    @UserDefault("optionalDataValue")
    var optionalDataValue: Data?
   
    @UserDefault("array", defaultValue: [1,9,6,1])
    var array: [Int]
    
    @UserDefault("arrayOfArray")
    var arrayOfArray: [[Int]]
    
    @UserDefault("dict")
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
    
    @UserDefault("users", defaults: UsersSource.defaults)
    var users: [User]
}

func test() {
    Settings.shared.arrayOfArray = [[1],[2,3]]
    print(Settings.shared.arrayOfArray)

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
    @UserDefault("activity")
    var activity: Activity?
}
