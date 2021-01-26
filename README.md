# UserDefaultPropertyWrapper

# Installation

Add to Podfile:
`pod `

Call 
`pod install`

# Usage
- You can use wrapper with base types: `Bool`, `Int`, `Double`, `Float`, `String`, `Date`, `Data`. You can use `Array` of any mentioned type (array of arrays as well), and `Dictionary`, where `Key == String` and `Value == any mentioned type`

- Types may be optional

- Moreover - you can use custom types, just make your type conform to the `UserDefaultsConvertible` protocol.

```
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

// Than use these properties as usual 

Settings.shared.optionalStringValue = "Some value"
print(String.shared.optionalStringValue)

Settings.shared.optionalStringValue = nil
print(String.shared.optionalStringValue)

```

# TODO: 
- Add example for custom types
- Add example for custom UserDefault (`UserDefault(suiteName:)`)
