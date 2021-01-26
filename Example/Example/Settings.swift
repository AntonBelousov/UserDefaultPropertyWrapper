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
    var array: [Int]
    
    @UserDefault("dict", defaultValue: [:])
    var dict: [String: Int]
}

func test() {
    Settings.shared.array = [1,2,3]
    print(Settings.shared.array)    
}
