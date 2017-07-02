# WolfBase/WolfCore Skins

The purpose of the WolfBase skinning machinery is to make it easy to define, refine, and update the look of your app. The goals of the skinning machinery are:

* Be as dynamic as possible, even allowing the look of the app to change dramatically at run-time or as defined by a server.
* Collect in one place much of the information about the colors, fonts, and other stylistic variations that give the app much of it's character.
* Allow different view controller and views to use or even create variations of the base skins defined by the app.
* Make it possible to make changes at high levels of the app that affect many things, or isolate smaller changes to smaller parts of the app that need custom appearances.
* Allow skins to smoothly interpolate from one to the other to allow for animated transitions.

## Major Types of Interest

### struct `FontStyle`

Encapsulates the information about a type style, including font family, face, and options for display such as whether text with this style applied should be shown in all capital letters.

##### ⚠️ You should never need to type literal strings in all caps. All caps is what is known as a *presentational fom*, like putting a dollar-sign before currency values or adding commas. Values are stored in *representational forms*, in the case of user-facing strings, use `Title Caps` in most cases.

### struct `Color`

Represents a simple, RGBA color using `Double` components. Skins store their colors as `WolfBase.Color`, not `UIColor`. This would not have been my first choice, but it turns out that making `UIColor` conform to a protocol (`Interpolable`) that lets a type define how it interpolates to another value of the same type isn't so easy because `UIColor` is actually a non-final abstract class that hides a number of concrete, undocumented subclasses. So if you ask to interpolate between `UIColor.black` (a grayscale color subclass) and `UIColor.red` (a predefined RGB color) you're already dealing with two different concrete types, with different numbers of components internally. If you create a `UIColor` by specifically providing the color components you're dealing with a third. `WolfBase.Color` on the other hand, is a simple `struct` with pure value-semantics, and already knows how to interpolate itself, as well as convert itself to `UIColor` (`.uiColor`) and from `UIColor` (`Color(uiColor)`). So you could write:

```swift
view.backgroundColor = skin.backgroundColor.uiColor
```

But WolfCore includes a custom operator, `©=`, called the "convert-then-assign" operator, to make assignments like this even simpler:

```swift
view.backgroundColor ©= skin.backgroundColor
```

### struct `SkinKey`

A `Skin` is basically a dictionary of key-value pairs. The keys need to be statically-defined, type-safe (to allow typing completion) and extensible without subclassing, since `Skin` is a value type not a reference type.

So `SkinKey` inherits from `WolfBase.ExtensibleEnumeratedName`. Think of this as like an `enum` that, unlike an actual `enum` isn't "closed" at it's first definition. You can add additional `SkinKey`s by extending the type:

```swift
extension SkinKey {
    public static let dogColor = SkinKey("dogColor")
}
```

WolfCore defines extension to `SkinKey` to support many typical iOS UI features. You can extend `SkinKey` further in your own frameworks and apps.

#### Dependent Keys

`SkinKey` has another feature: each `SkinKey` instance has a list of other `SkinKey`s that are *dependent* upon this one. Basically, this means what when the value of this key changes, all of its dependent keys become invalid, along with *their* dependent keys, recursively. This means that later when those dependent keys are accessed, they will be re-computed to take the updated key into account.

If you look inside `Skin-iOS.swift`, you'll see the following snippet:

```swift
extension ConcreteSkin {
    public mutating func applyDefaults() {
        // ...

        SkinKey.tintColor => [
            .highlightedTintColor,
            .navbarTintColor => [
                .toolbarTintColor,
                .segbarTintColor
            ],
            .sliderThumbColor
        ]

        // ...
    }
}
```

The `=>` operator is the same "Assign-Nesting" operator you're already familiar with in WolfCore for easily creating view hierarchies. But in this case it is being repurposed to define a hierarchy of dependent `SkinKey`s. In the example above, it means that when `Skin.tintColor` is assigned, internally the values behind all the other keys you see below it will be cleared, meaning that the next time they are accessed they will be re-computed based on the new `tintColor`.

##### ✅ `ConcreteSkin` and `InterpolatedSkin` are two value types (`struct`) that conform to the `Skin` protocol. You'll extend `ConcreteSkin` to set up large `Skin` variants, and you'll receive `InterpolatedSkin` instances from the `Skin.interpolated(to:frac:)` function. You won't need to make any other types conform to `Skin`.

### protocol `SkinValue`

The values in a Skin's key-value pairs need to support interpolation and equality-checking:

```swift
public protocol SkinValue: Interpolable, Equatable {
}
```

`Interpolable` is defined thusly:

```swift
public protocol Interpolable {
    func interpolated(to other: Self, at frac: Frac) -> Self
}
```

`Frac` is simply a `typealias` for `Double`, but it's there to remind you that it should always stay in the range 0.0 ... 0.1.

Obviously colors can be blended smoothly from one to another. And it's up to you how to define how the types you use interpolate. Here's how `Color` conforms to `Interpolable`:

```swift
extension Color: SkinValue {
    public func interpolated(to other: Color, at frac: Frac) -> Color {
        return blend(from: self, to: other, at: frac)
    }
}
```

But let's take `Bool` as an example of a type that conforms to `Interpolable` but can't move as smoothly:

```swift
extension Bool: SkinValue {
    public func interpolated(to other: Bool, at frac: Frac) -> Bool {
        return frac.ledge(self, other)
    }
}
```

`ledge` is a function defined in `MathUtils.swift` as an extension on the `BinaryFloatingPoint` protocol. That means that any binary floating point type like `Float`, `Double`, and `CGFloat` and use it. It returns the first argument if `frac` is < 0.5 and the second if not.

##### ✅ If you have general floating-point interpolation to do, also look at the `WolfBase.Interval` type and the `mapped` functions in `MathUtils.swift`.

### protocol `Skin`

`SkinKey`s are basically just symbolic names and used to index into a Skin's internal dictionary. By themselves they don't define the data type to which they refer.

##### ✅ By convention WolfCore ends skin Colors with the suffix `xxxColor` and FontStyles with the suffix `xxxStyle`.

So here's an example of defining a couple new attributes on `Skin`:

```swift
extension SkinKey {
    public static let balloonColor = SkinKey("balloonColor")
    public static let headlineStyle = SkinKey("headlineStyle")
}

extension Skin {
    public var balloonColor: Color {
        get { return get(.balloonColor, .red) }
        set { set(.balloonColor, to: newValue) }
    }

    public var headlineStyle: Color {
        get { return get(.headlineStyle, FontStyle(.headlineStyle, font: .systemFont(ofSize: 48), color: .blue)) }
        set { set(.headlineStyle, to: newValue) }
    }
}
```

We are extending the `Skin` protocol to include two new computed attributes, `balloonColor` and `headlineStyle`. We are defining a Swift getter and setter (`get { ... }` and `set { ... }`) for each, and within the getters and setters we are calling the functions `get` and `set` provided by the `Skin` protocol itself.

The `Skin.get()` method takes two arguments: the first is the `SkinKey` and the second is the default value of the attribute. Skins *always* return values— they never return optionals or `nil`.

Actually the default value is a bit more clever than that because the default argument is actually a Swift `@autoclosure` which means it's a bit of code that runs when needed and returns the value you see. Why is this important? It means that the initialization of each attribute can reference other attributes *whether or not they themselves have yet been initialized*. This means that if you want to make an attribute that references say, the `Skin.tintColor` attribute you can do so without caring whether the `tintColor` attribute has been initialized yet (or indeed, overwritten).

##### ✅ Note that `FontStyle` is also initialized with the `SkinKey`. This is helpful for debugging output. Extensive logging can be turned on by calling `logger.set(group: .skin, active: true)`, which is normally found in `AppDelegate.setupLogging()`.

Since `Skin` is essentially a dictionary internally, all it's values are determined by latest-write-wins. This means that variants can be created on Skins by writing to values at a later time. If you write to a value referenced by a dependent key of another value, it will persist until it is again overwritten or any of the keys upon which it is dependent are overwritten.

So while base default values in skins are provided as part of the attribute getters (to facilitate making values dependent on other values without regard to the order they appear in the code) variants, (like making a dark-background skin based on a pre-existing light-background skin) are done like this:

```swift
//
// This is excerpted from WolfCore Skin-iOS.swift
//
extension ConcreteSkin {
    /// This adds anything necessary for the basic light-background skin, like dependent keys.
    public mutating func applyDefaults() {
        // ...
        SkinKey.topbarColor => [
            .toolbarBarColor,
            .segbarBarColor
        ]
        // ...
    }

    /// This starts with the basic defaults and then applies a variant over them.
    public mutating func applyDarkDefaults() {
        applyDefaults()

        addIdentifier("dark")

        // ...

        statusBarStyle = .lightContent
        viewControllerBackgroundColor = .black
        textColor = .white

        // ...
    }
}
```

The app then proceeds to add and define it's *own* new attributes to the basic iOS skins provided by WolfCore.

```swift
//
// This is excerpted from AppSkin.swift
//
extension SkinKey {
    public static let theme1Color = SkinKey("theme1Color")
    // ...
    public static let header1Style = SkinKey("header1Style")
    // ...
}

// ...

extension Skin {
    public var theme1Color: Color {
        get { return get(.theme1Color, .appTheme1) }
        set { set(.theme1Color, to: newValue) }
    }

    // ...

    public var header1Style: FontStyle {
        get { return get(.header1Style, FontStyle(.header1Style, family: .antonio, face: .regular, size: 40, color: .white, allCaps: true)) }
        set { set(.header1Style, to: newValue) }
    }

    // ...
}

// ...

extension ConcreteSkin {
    /// This bases the app defaults on WolfCore's defaults.
    public mutating func applyAppDefaults() {
        applyDefaults()

        addIdentifier("appLight")

        SkinKey.theme1Color => [
            .header2Style,
            .header3Style,
            // ...
        ]

        // ...

        // These overwrites some of WolfCore's defaults
        topbarColor = theme1Color
        // ...
        textFieldContentStyle = FontStyle(.textFieldContentStyle, family: .openSans, face: .regular, size: 13, color: .appDarkestGray)
        // ...
    }

    /// This bases the app dark-background defaults on the app light-background defaults,
    /// *not* the WolfCore dark-background defaults.
    public mutating func applyDarkAppDefaults() {
        applyAppDefaults()

        addIdentifier("appDark")

        tintColor = .white
        textColor = .white
        navbarBlur = false
        // This creates and overwrites an existing FontStyle with a variant of just a different color
        textFieldContentStyle = textFieldContentStyle.withColor(.white, "white")

        // ...
    }
}
```

##### ✅ The calls to `Skin.addIdentifier()` and the string added as an argument to `FontStyle.withColor()` are used to add debugging information to each skin that forms an "audit trail" of changes when viewed in the console with `.skin` logging turned on.

### The Top-Level Skins

WolfCore has three global variables it uses to keep track of the highest-level skins the app uses: `lightSkin`, `darkSkin`, and `topSkin`. By default `topSkin` is assigned a copy of `lightSkin`. Before `topSkin` is read the first time, the app can assign its own skins to `lightSkin` and `darkSkin`, and `topSkin` too if desired.

### The `skin` Variable

WolfCore extends `UIView` and `UIViewController` to have an attribute `public var skin: Skin!`. This is available on *all* views and view controllers regardless of whether they conform to the `Skinnable` protocol (see below).

The `skin` attribute is a force-unwrapped conditional because although it will *never* be `nil` upon reading, it can have `nil` written to it to remove the overriding skin from that object.

Internally a view or view controller may contain an overriding `Skin`, or may not. When the `skin` attribute is read, the *effective* `Skin` is returned, which may be the overriding skin or the one above it in the view hierarchy, or the one of the owning view controller, or as a last resort, the one in `topSkin`.

When a new value `skin` is written to a view, it initiates a recursive cascade of propagation to the view's current subviews. When written to `skin` on a view controller, it may modify attributes of the view controller itself and also the view controller's `view` and its subviews. As each subview is traversed, it is checked for several things:

* If the view conforms to `Skinnable`, calls are made to it to ask whether the view wants to revise the skin before using it, and then offered the chance to distribute the skin's attributes to its subviews and/or their skins.

* If the view doesn't conform to `Skinnable` it is still traversed but seen as "transparent"— it neither uses nor modifies the skin being propagated.

* If the view has an overriding skin in it's `skin` attribute, it blocks further traversal down below it.

##### ⚠️ It is *extremely* important to realize that writing to a `skin` attibute in *any* way, even by changing an attribute deep-inside it, like the color of a FontStyle, will trigger a copy-on-write operation that results in new, overriding skin being written to the owning object, and the cascade of propagation of the new revised skin. This is by design. Skins have value semantics, and this makes copying skins without changing them highly efficient and keeps all the values in them distinct from all other instances.

```swift
topSkin.tintColor = .blue
var mySkin = topSkin
mySkin.tintColor = .red
print(topSkin.tintColor) // prints .blue
print(mySkin.tintColor) // prints .red
```

```swift
myLabel.fontStyle = skin.header1Style // triggers a change to myLabel.skin and propagation to subviews.
```

### protocol `Skinnable`

Views and view controllers (or anything else) that conform to `Skinnable` are given the opportunity to modify a skin before it is applied, and to distribute it's attributes to itself and other subviews. These are two separate phases: `reviseSkin()` and `applySkin()`. They are called on each `Skinnable` object in that order.

```swift
public protocol Skinnable: class {
    var skin: Skin! { get set }
    func reviseSkin(_ skin: Skin) -> Skin?
    func applySkin(_ skin: Skin)
}
```

#### `reviseSkin()`

`reviseSkin()` gives the `Skinnable` object the chance to make changes to the skin before they are applied and propagated further. It takes as its argument the skin being propagated and returns an optional `Skin`. if `nil` is returned (the default if not overridden), it indicates that this `Skinnable` does not wish to make any changes. If an actual `Skin` is returned, this is assigned as the overriding skin for the `Skinnable` and it is the skin which continues propagation.

If the `topSkin` is a light-background skin and you want to have a view controller that has a dark background, you can simply write this in your view controller:

```swift
override func reviseSkin(_ skin: Skin) -> Skin? {
    return darkSkin
}
```

With a little more effort you can add a paper-trail for debugging. As the passed in `skin` is a `let` constant, you have to assign it to a `var` before you can make changes.

```swift
override func reviseSkin(_ skin: Skin) -> Skin? {
    var skin = darkSkin
    skin.addIdentifier("startup")
    return skin
}
```

If you want to actually *modify* the propagating skin rather than fully replace it, you need to make sure you call super's implementation. If super passes back nil, then you stil need to work with the skin you were passed. The first line of code in the method below does all this:

```swift
public override func reviseSkin(_ skin: Skin) -> Skin? {
    var skin = super.reviseSkin(skin) ?? skin
    skin.addIdentifier("videoPlayer")
    skin.tintColor = .white
    return skin
}
```

##### ⚠️ If you want to make several aggregated changes to a skin, don't make them directly to attributes on the `skin` attribute of a view controller or view, unless you're making a single change. Every write you do will trigger propagation. Instead make all the changes to a local copy of the skin before writing it back to `skin`.


#### `applySkin()`

The reason why `applySkin()` is distinct from `reviseSkin()` is that you never want to trigger propagation from above you in the hierarchy-- This would result in infinite recursion and a crash. `reviseSkin()` gives you an opportunity to change a skin before changing it would do so.

`applySkin()` is there to let you distribute skin-level changes to the rest of your views, or to modify the overriding views of subviews. In this example, during `setup()` the label will be added to the view. At `setup()` time, we don't even know if the view has a superview yet, so it wouldn't make sense to assign anything to the view's `skin`, as we'd just be changing a copy of `topSkin` and not the one we'll later receive from the view controller or a superview. So when `applySkin()` is called below, it copies the `.header1Style` attribute from its skin to the `fontStyle` property of `titleLabel`, which actually triggers a change to the `labelStyle` property on the label's skin, assigning it the `header1Style` `FontStyle`.

```swift
class MyView: View {
    lazy var titleLabel: Label = {
        let label = Label()
        return label
    }()

    override func applySkin(_ skin: Skin) {
        super.applySkin(skin)
        titleLabel.fontStyle = skin.header1Style
    }

    override func setup() {
        super.setup()
        self => [
            titleLabel
        ]
        // ...
    }
}
```

⚠️ I recommend making all "skin-like" changes in `applySkin()`. This would include setting things like backgroundColor of your view from a constant color (rather than a skin attribute) because this provides a consistent place to make such changes and know they'll all happen at the same time.

⚠️ If you add a view to the view hierarchy late, it will *not* automatically receive it's superview's skin. After it is done making changes to the hierarchy, the view that adds the new subview(s) can call `propagateSkin(why:)` to propagate its current skin to all its subviews.

✅ I recommend searching the code for instances of `reviseSkin()` and `applySkin()` to see various techniques for how they're used. There are a small number of common patterns.
