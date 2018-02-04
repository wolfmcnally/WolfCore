# WolfCore

[![CI Status](http://img.shields.io/travis/ironwolf/WolfCore.svg?style=flat)](https://travis-ci.org/ironwolf/WolfCore)
[![Version](https://img.shields.io/cocoapods/v/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)
[![License](https://img.shields.io/cocoapods/l/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)
[![Platform](https://img.shields.io/cocoapods/p/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)

WolfCore is a library of conveniences for constructing Swift applications in iOS, tvOS, MacOS, WatchOS, and Linux.WolfCore is maintained by Wolf McNally.

Over the years I've carried a continuously-evolving tool kit of software tools and techniques that I use to avoid re-inventing the wheel. It's had many iterations over the years and WolfCore is the latest— open source (MIT license), cross-platform (iOS, MacOS, tvOS, WatchOS, and Linux), pure Swift (including Foundation and GCD under Linux) It's basically a collection of embodied conveniences and best practices that make the code built on it easier to read, write, and maintain, often reducing or eliminating the need for boilerplate code.

The purpose of WolfCore is different than many third-party libraries. It neither solves a narrow problem, like many do, nor does it dictate the structure of how the whole app is written, like Xamarin or even UIKit does. It's purpose is to be a general purpose tool kit that streamlines the code that performs the actual work of the app. Its use, while optional at every step, reduces the number of lines of code you actually have to write and understand, and it covers areas that are common in many productivity apps. WolfCore reduces the need to add third-party libraries (which often integrate poorly with one another).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

WolfCore is written in Swift 4.0.

## Installation

WolfCore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WolfCore'
```

## Author

ironwolf, wolf@wolfmcnally.com

## License

WolfCore is available under the MIT license. See the LICENSE file for more info.
