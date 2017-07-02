# WolfBase Promises

## Complete Working Example

The following example uses promises to access the Google Places API to return a list of suggested cities that possibly match a string the user is typing into a search field.

```swift
//: Playground - noun: a place where people can play

import Foundation
import WolfBase
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public struct City: JSONModel {
    public let json: JSON

    public init(json: JSON) {
        self.json = json
    }

    public var name: String {
        return try! json.value(for: "description")
    }

    public var description: String {
        return name
    }
}

public func getCities(for searchString: String) -> Promise<[City]> {
    return Promise<[City]> { promise in
        let host = "maps.googleapis.com"
        let path = "/maps/api/place/autocomplete/json"
        let apiKey = "AIza..." // Your API key here.
        var components = URLComponents()
        components.scheme = HTTPScheme.https.rawValue
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "input", value: searchString),
            URLQueryItem(name: "types", value: "(cities)"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        print(components)
        let url = components.url!
        let request = URLRequest(url: url)
        HTTP.retrieveJSONDictionary(with: request).map(to: promise) { (promise, json) in
            let predictions: JSON.Array = try! json.value(for: "predictions")
            let cities = predictions.map { prediction -> City in
                let prediction = try! JSON(value: prediction)
                return City(json: prediction)
            }
            promise.keep(cities)
        }
    }
}

getCities(for: "Springfield").then { cities in
    print(cities.flatJoined(separator: .newline))
}.catch { error in
    print("error: \(error)")
}.finally {
    PlaygroundPage.current.finishExecution()
}.run()
```
The above code prints:
```
Springfield, MO, United States
Springfield, OR, United States
Springfield, IL, United States
Springfield, VA, United States
Springfield, OH, United States
```

🐺
