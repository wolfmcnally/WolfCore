# WolfBase Lazy Instantiation

### Example

```swift
// This is a subclass of an Objective-C view
class ActivityIndicatorView: View {
    // ...
}
```

###### Before:

```swift
private lazy var activityIndicatorView: ActivityIndicatorView = {
    let view = ActivityIndicatorView()
    // Additional one-time customization goes here
    return view
}()
```

###### Won't work:

```swift
private lazy var activityIndicatorView = ActivityIndicatorView()
```
❌ **"Type of expression is ambiguous without more context."**

###### Works but wordy:

```swift
private lazy var activityIndicatorView: ActivityIndicatorView = ActivityIndicatorView()
```

###### Works:

```swift
private lazy var activityIndicatorView: ActivityIndicatorView = .init()
```

### Example

```swift
// This is a pure Swift class
public class KeyboardNotificationActions {
    // ...
}
```

###### Works
```swift
private lazy var keyboardNotificationActions = KeyboardNotificationActions()
```

### Example

###### Works but wordy:
```swift
private lazy var placeholderMessageContainer: HorizontalStackView = {
    let view = HorizontalStackView()
    view.alignment = .center
    view.spacing = 10
    view.alpha = 0
    return view
}()
```

###### Better:
```swift
private lazy var placeholderMessageContainer: HorizontalStackView = .init() • {
    $0.alignment = .center
    $0.spacing = 10
    $0.alpha = 0
}
```

###### Nicer:
```swift
private lazy var placeholderMessageContainer: HorizontalStackView = .init() • { 🍒 in
    🍒.alignment = .center
    🍒.spacing = 10
    🍒.alpha = 0
}
```

##### ✅ To type emoji easily in Xcode, create a "text snippet" that autocompletes `$c` to `🍒`.

##### ✅ Create a text snippet in Xcode that autocompletes from `plv` to easily let you follow the above pattern:
```swift
private lazy var <#name#>: <#Type#> = .init() • { 🍒 in
    <#code#>
}
```
