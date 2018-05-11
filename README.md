# WolfCore

[![CI Status](http://img.shields.io/travis/ironwolf/WolfCore.svg?style=flat)](https://travis-ci.org/ironwolf/WolfCore)
[![Version](https://img.shields.io/cocoapods/v/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)
[![License](https://img.shields.io/cocoapods/l/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)
[![Platform](https://img.shields.io/cocoapods/p/WolfCore.svg?style=flat)](http://cocoapods.org/pods/WolfCore)

WolfCore is a library of conveniences for constructing Swift applications in iOS, tvOS, MacOS, WatchOS, and Linux. WolfCore is maintained by Wolf McNally. See Below for my manifesto.

## Requirements

WolfCore is written in Swift 4.1.

## Installation

WolfCore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WolfCore'
```

## Author

wolfmcnally, wolf@wolfmcnally.com

## License

WolfCore is available under the MIT license. See the LICENSE file for more info.

# WolfCore: The Master’s Workshop

## The Master and the Mentor

I am an iOS software developer, and I am a master at what I do. I am not using this term arrogantly— I am using it according to the following dictionary definitions:

1. A worker or artisan qualified to teach apprentices, or
2. A highly-skilled and accomplished artist, performer, or player.

I have long been inspired by the “tradeguild model” of learning. (In fact, due to that inspiration I and several partners founded a video game development company back in the 1990’s called *The Dreamers Guild*.)

In the tradeguild model, the *apprentice* works at the side of the master, watching how the craft is performed, and learning by doing under the master’s direction and supervision. The *journeyman* started as an apprentice, and now works independently, traveling to visit customers and learn from other masters. The *master* has long experience and accomplishments, and determines when an apprentice is ready to become a journeyman, and helps judge a journeyman’s “master work” (*“masterpiece”*) to determine whether they are ready to become a master themselves.

(If you prefer an absolutely gender-neutral term, I recommend *journeyer*.)

I am also a mentor. A mentor is not dissimilar in level of skill and accomplishments to a master, but the role more connotes that of “trusted counselor or guide.” The job of a mentor, as I see it, is to help the mentee: 1) find their path, and 2) provide knowledge and wisdom to help them navigate their path. It is up to the mentee to actually *walk* the path.

The most obvious difference between a master/apprentice relationship and a mentor/mentee relationship is that the master actively assigns and evaluates work, while the mentor provides counsel and guidance.

A mentor basically waits for the mentee to approach with stories of their journey, and problems they’re trying to solve, and helps them understand the problems more deeply and make choices about how to deal with them.

A master actually dictates what work is to be done and specifies the level of workmanship necessary to do it.

Mentors and masters each face unique problems. Both face the problem of finding worthy mentees and apprentices— aside from raw talent, they have to be *teachable*. Mentors face the problem of only having “soft power”— they must passively wait for the mentee to approach. Masters can judge and reject the quality of work, but face the problem of apprentices who are too inexperienced to know how little they actually know.

The image of the mentor is of a wise person sitting in a chair, listening. The image of a master is of an aproned crafter in their workshop, surrounded by their tools, their works in progress, and their amazing creations.

As I said, I am both a mentor and a master— as a mentor I am capable of answering questions and providing wisdom and encouragement as needed. As a master I am capable of taking an unformed talent and elevating it to a great talent.

Assuming they want me to.

## So What is WolfCore?

Using the above as analogy, WolfCore is my “master’s workshop.”

I have stood in other masters’ workshops— a stained glass artist, a furniture designer, an electronic musician, a concept car creator, even a castle builder. When you stand in such a space in a mindset to properly appreciate it, you can’t help but feel awe at the amount of time, effort, and knowledge that has gone into creating this space of creation. Gazing at its details, one notices how the tools and work areas are carefully chosen, organized, and arranged. Some of the details might be intensely personal and even quirky. But the space’s utility is undeniable.

As programmers we’re used to dealing with conceptual boxes-within-boxes. My home holds my office— my workshop. My office holds my computer running Xcode— a workshop within a workshop. Xcode provides tools to create iOS software— the Swift standard libraries and iOS APIs are another nested workshop. Finally there is WolfCore, a set of “embodied conveniences”— *tools*— I use to create great software.

I truly appreciate the cornucopia of open-source software. Almost every project I do incoporates one or more third-party open-source libraries. What distinguishes WolfCore from other open-source software frameworks and libraries is that while those libraries are often aimed at providing specific functionality, WolfCore is aimed at providing general convenience in a myriad of tasks I commonly encounter when writing apps.

What do I mean by “convenience?”

* Do it DRY
* Do it Best
* Do it Swifty
* Do it Elegantly
* Do it Cross-Platform

### Do it DRY

DRY stands for *Don’t Repeat Yourself* and is a principle of software development aimed at reducing redundancy and increasing code reuse. Writing an app on iOS (and indeed any operating system) involves semantically singular tasks, “write the file to disk”, that may involve several lines of code “check for the file’s existence, delete the file if it already exists, create the new file, open the new file, encode the data, write the data, close the file.” While it’s necessary to have this level of flexibility in the operating system, the main business logic of the app simply wants to write the file. Moreover, the file may be read, written, or manipulated from several points in the code, dictated again by the business logic.

It’s a basic piece of programming practice that, when one discovers oneself writing the same code twice, it’s time to refactor. Once you’ve refactored those lines of code into a reusable unit, that unit should be used from then on. For me, when I find myself doing something over and over this way, and I believe the refactored solution would be generally useful in many projects, I put the solution into WolfCore. Invoking this solution rarely requires more than one line of code, and so the top-level business logic becomes more understandable and more maintainable in the process.

**EXAMPLE:** See the `newImage()` function in the file `ImageUtils.swift`.

### Do it Best

Just as there is “more than one way to skin a cat,” there are many ways to accomplish a particular UI or processing task in a given language and OS. But not all approaches are equal: some use outdated APIs, some are inefficient, some are insufficiently flexible, or are too flexible and require too much thought to use, and some are hacks that can break in unexpected ways, or fail to work around known issues in the OS.

When I identify a best practice or the “best” way to accomplish a particular task, it becomes part of WolfCore.

A good example of this in WolfCore is the class `ScrollingStackView`. When iOS programmers want to create forms they often turn to table views. This is problematic in several regards, not the least of which is that it includes a lot of code overhead to set up. This is unnecessary overhead because table views can be arbitrarily long, and have to support that. Stack views arrange their views in vertical or horizontal stacks that are easy to lay out and manipulate, but unlike table views they don’t by themselves have scrolling machinery built in. Finally, neither stack views nor table views get out of the way of the software keyboard when it appears while the user enters text into a form field. If this isn’t handled carefully, the keyboard may cover what the user is typing, or may be difficult to dismiss.

`ScrollingStackView` solves all these problems and more. Here is the comment at the top of `ScrollingStackView.swift`:

```swift
//  keyboardAvoidantView: KeyboardAvoidantView
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >
```

This class combines several best practices. The outmost view is a `KeyboardAvoidantView` which does exactly what it says: it automaticaly resizes itself to avoid the software keyboard. Dealing with avoiding the keyboard is a nasty and error-prone business, and all this is hidden by `KeyboardAvoidantView`. When the keyboard appears, it gets shorter. This causes the `outerstackView` to get shorter too, meaning the header views (above the `scrollView`) and footer views (below the `scrollView`) remain visible. The `stackView` inside the `scrollView` contains all the views you want to become scrollable if they don’t fit in the visible area.

This is an example of a simple, robust, reusable solution that I use in virtually every app I write. It is literally a “best” solution I have found to several common problems, so it belongs in WolfCore.

### Do it Swifty

*Closures* are inline anonymous functions that, while a tacked-on feature to Objective-C as *blocks* are designed into the Swift programming language from day one. Since Objective-C did not have blocks from its inception, many of its APIs use design patterns that predate blocks. One such pattern is the *target-action* pattern, where a callback (like, what to do when a button is tapped) is registered with an API by identifying 1) the object to be called back, and 2) the *selector*, or function identifier to be called back when the event happens. This pattern has several disadvantages:

* The callback must be manually unregistered, or a memory leak or crash may result.
* The callback code may be far away from the place in the code where it is registered and unregistered— even in a different object of a different class.
* The callback function must be declared as Objective-C accessible using the `@objc` attribute.
* A separate named function must be created for a single purpose— to be called by the operating system.

#### The basic iOS way of adding a gesture recognizer (18 lines of code):

```swift
class MyView: UIView {
    var tapRecognizer: UITapGestureRecognizer!

    func addTapAction() {
        tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(.handleTap))
        addGestureRecognizer(tapRecognizer)
    }

    func removeTapAction() {
        removeGestureRecognizer(tapRecognizer)
        tapRecognizer = nil
    }

    @objc func handleTap() {
        print("tapped!")
    }
}
```

#### The WolfCore way of adding a gesture recognizer (13 lines of code):

```swift
class MyView: UIView {
    var tapAction: GestureRecognizerAction!

    func addTapAction() {
        tapAction = addAction(for: UITapGestureRecognizer()) { _ in
            print("tapped")
        }
    }

    func removeTapAction() {
        tapAction = nil
    }
}
```

Not only is the WolfCore version 5 lines shorter, imagine what would happen if, in the first example, `removeTapAction()` were called either before the recognizer was added, or after it was removed— a crash due to the attempt to force-unwrap `tapRecognizer`. It is code like this that gives force-unwrapping a bad name. Now examine the WolfCore code. The `GestureRecognizerAction` class is designed to use the *Resource Acquisition is Initialization* (RAII) idiom, which means that the lifetime of the object is also the lifetime of the registration. Unregistration will happen automatically when the view itself is deinitialized, or manually when `nil` is assigned to `tapAction`. This also means that the WolfCore version of `removeTapAction()` is *idempotent*— it can be called additional times without additional effect, including a crash. To add idempotence to the first example, an additional guard line of code would have to be added to `removeTapAction()`.

So not only is the WolfCore version shorter, it also uses Swifty closures instead of the outdated target-action pattern and its attendant reference to Objective-C. And on top of that, it is also less crash-prone.

**MORE:** See the `GestureRecognizerAction` class in the file `GestureRecognizerAction.swift`.

### Do it Elegantly

Elegance and beauty are things that programmers understand when it comes to code, or at least they ought to. To a mathematician’s eyes, an equation that is beautiful is also more likey to be correct and parsimonious— neither more nor less complex than called for by the problem. When a solution is beautiful it also calls attention to its correctness. For example, which code would you rather write or read?

#### The basic iOS way of nesting views:

```swift
view1.addSubview(view2)
view2.addSubview(view3)
view2.addSubview(stackView)
stackView.addArrangedSubview(view4)
stackView.addArrangedSubview(view5)
```

#### The WolfCore way of nesting views:

```swift
view1 => [
    view2 => [
        view3,
        stackView => [
            view4,
            view5
        ]
    ]
]
```

The WolfCore version has several advantages:

* The code is more visual, using the IDE’s natural indentation to show the hierarchical structure, and without the visual “buzz” of the repeated `addSubview` and `addArrangedSubview` symbols.
* The code is easier to debug. Sibling order and grouping is obvious by inspection, any view or subset can be removed by commenting the relevant line(s), and a whole level can be collapsed into its parent level by commenting out the line with the nesting operator and its corresponding line with the close bracket.
* The nesting operator `=>` is polymorphic. Here it is used to call either `addSubview()` or `addArrangedSubview()` depending on whether the object to the left of the operator is derived from `UIView` or more specifically derived from `UIStackView`.
* Because of the polymorphism, it is harder to make common errors. calling `addSubview()` on a `UIStackView` is rarely what you want to do and will lead to unexpected behavior, but what you do most commonly on a `UIView`. Using the nesting operator takes care of the most common use-cases for both kinds of parent views in a uniform and elegant way.
* The nesting operator can easily be extended to any sort of hierarchy creation, for example creating view graph hierarchies with `SpriteKit` or `SceneKit`.

**MORE:** See `NestingOperator.swift` and `ViewNesting.swift`.

### Do it Cross-Platform

Swift was introduced by Apple as a replacement for Objective-C that powers macOS, iOS, tvOS, and watchOS. But Swift was also designed to be a generic systems-programming language. Apple has open-sourced Swift and it now runs on several hardware platforms and operating systems, including Linux. The Swift standard library is completely platform agnostic. IBM has several public initiatives to advance Swift as a language of choice for server-side development.

Although I specialize in iOS development, I have also done full-stack development, and I’m excited about the possibilities for Swift on other platforms. Within the Apple environments, Swift is now the unifying factor.

So I have designed WolfCore to be cross platform. Many WolfCore files depend only on the `Foundation` and `Dispatch` frameworks, which are completely cross-platform. Within the files shared by the Apple environments, I have adopted the convention of using typealiases starting with `OS` to denote types that can be used across both iOS and macOS. For example, the file `OSImage.swift` largely unifies `UIImage` from iOS and `NSImage` from macOS, enabling you to more easily write code that runs on either Mac or iOS devices.

## From the Workshop to the Maker Space

Parts of WolfCore are literally decades old. They were once written in C, then C++, then Java, then Objective-C, and now Swift. I have carried them throughout my career and they have proven their usefulness, and they have undergone refinement at every step. Currently every project I do simultaneously contibutes small additions to WolfCore and benefits hugely from what is already there.

On the downside, WolfCore currently lacks documentation and unit testing. It is a major initiative for me to correct this, both by adding unit tests, and in-code documentation, and by writing “The WolfCore Book” which will be a series of blog posts expounding on aspects of WolfCore and good Swift design principles in general.

The other downside is that a few parts of WolfCore really belong in their own frameworks, because they are not highly reused between projects. The actual savings in code size for doing this will not be great: WolfCore in its entirety currently weighs in at 7.8 MB, while the Swift Standard Libraries, which must be included with every Swift-based app, weighs in at 25.3 MB. It is likely that the iOS build of WolfCore, once it is fully refactored into dependent sub-frameworks, will be about 4 MB.

Finally, another inspiration to me is the *maker movement*. This groundswell of do-it-yourself technological creators has given rise to public *maker spaces* which provide tools and expertise to anyone who desires to create and who is willing to take the time to learn how to properly use them. WolfCore is the latest incarnation of my “master’s workshop”. Now I am inviting everyone in. It’s an “open house” and I am looking to find those willing to help transform it from my personal productivity space into a public “maker space” where thousands can feel comfortable creating and learning.

🐺 Wolf McNally
