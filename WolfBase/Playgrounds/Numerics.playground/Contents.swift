/*:
 # WolfCore Numerics
 © 2017 Wolf McNally. Released under the MIT license. See [WolfMcNally.com](http://wolfmcnally.com) for more information.

 ## Introduction

 The functions in this section are written in pure Swift and are entirely cross-platform.
 */
import WolfBase
/*:
 ## Fractional Values

 `Frac` is simply a `typealias` for `Double`. a `Frac` represents a fractional value expected to stay between 0.0 and 1.0. It's useful for interpolation, animation, and other things expressed as fractions like color components.

 `public typealias Frac = Double`
 */
let f: Frac = 0.5
//: Since it's just a `Double`, a `Frac` can't actually constrain its values to betwen 0 and 1, but you can do it by calling `clamped()` on any floating point value (not just `Frac`.)
let f2: Frac = 0.5.clamped()  // f2 == 0.5
let n: Double = 2.0.clamped() // n == 1.0
var r: Frac = 1.2             // r is currently -1.2
r = r.clamped()               // r is now 1.0
//: Sometimes you want to know whether a `Frac` is "less than halfway." That's what `ledge()` is for. It's designed to be used with the *ternary operator*:
let whereAmI = 0.2.ledge() ? "gettingStarted" : "almostDone"  // whereAmI == "gettingStarted"
let whereAmINow = 0.9.ledge() ? "gettingStarted" : "almostDone"   // whereAmINow == "almostDone"
//: You can also use `ledge()` with two expressions:
for i in stride(from: 0, to: 1, by: 0.1) {
  print(i, i.ledge("gettingStarted", "almostDone"))
}
/*:
 Prints:
 ````
 0.0 gettingStarted
 0.1 gettingStarted
 0.2 gettingStarted
 0.3 gettingStarted
 0.4 gettingStarted
 0.5 almostDone
 0.6 almostDone
 0.7 almostDone
 0.8 almostDone
 0.9 almostDone
 ````
 */
//: 🐺
