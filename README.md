# UserDefaultPropertyWrapper

# Installation

Add to Podfile:
```
use_frameworks!
pod 'UserDefaultPropertyWrapper', :git => 'https://github.com/AntonBelousov/UserDefaultPropertyWrapper'
```

Call 
`pod install`

# Features
- You can use wrapper with base types: `Bool`, `Int`, `Double`, `Float`, `String`, `Date`, `Data`. You can use `Array` of any mentioned type (array of arrays as well), and `Dictionary`, where `Key == String` and `Value == any mentioned type`

- Type may be optional

- You can use custom types, just make your type conform to the `UserDefaultsConvertible` protocol.

- Some types has predefined default values: `false` to `Bool`, `0` for `Int`, `Float`, `Double`, `nil` for `Optional`, empty collection for `Array` and `Dictionary`. You can specify default values for other types (see `UserDefaultsConvertibleWithDefaultValue`)

# Usage
```
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

// Than use these properties as usual 

Settings.shared.optionalStringValue = "Some value"
print(String.shared.optionalStringValue)

Settings.shared.optionalStringValue = nil
print(String.shared.optionalStringValue)

```
# Custom types

You can make any type conform to the `UserDefaultsConvertible` protocol

```
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

ActivityStorage().activity = .reading(book: "Hearts of Three")
print(ActivityStorage().activity ?? "nil")
```

## Using `Codable`

If your type conforms to the [`Codable`](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) protocol, you can easily make if conform `UserDefaultsConvertible`. Just add `UserDefaultsConvertible` after type name and it will became convertible  automatically:

```
struct User: Codable, UserDefaultsConvertible {
    var firstname: String
    var lastname: String
    var birthdate: Date
    var address: String
}
```


# Custom user defaults
Note. You can use UserDefauls to share data between your application and app extension [see](https://www.swiftbysundell.com/articles/the-power-of-userdefaults-in-swift/#sharing-data-within-an-app-group)

```
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

func someMethodInApp() {

    let user = User(
        firstname: "Artur",
        lastname: "Fleck",
        birthdate: Date(timeIntervalSince1970: -729345600),
        address: "Arkham Asylum, Gotham County, New Jersey, United States of America")
    
    var source = UsersSource()
    source.users.append(user)
}

func someMethodInExtension() {
    source = UsersSource()
    print(source.users)
}

```
