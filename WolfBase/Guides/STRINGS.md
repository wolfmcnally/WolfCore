# WolfBase Strings and Attributed Strings

## Swift String and String Ranges. vs NSString and NSRange

`NSString` is composed of UTF-16 code units, and `NSRange` assumes underlying UTF-16. `NSRange` instances with arbitrary `location` values may cut into characters that have more than one 16-bit word in their encoding. Swift has a better model for Strings which accounts for all underlying Unicode encodings and the fact that they may have variable-length characters ("extended grapheme clusters"). `WolfBase.AttributedString`, which is a typealias for `NSMutableAttributedString`, provides additional methods that take Swift String ranges, and which should be used instead of the existing methods that take NSRange instances.

```swift
public typealias StringIndex = String.Index
public typealias StringRange = Range<StringIndex>
````

StringRange instances must be created in the context of the particular string to which they apply. Internally, a StringIndex carries a reference to the String from which it was created. Therefore, applying a StringIndex or StringRange created in the context of one string to another string without first converting it produces undefined results. Convenience methods are provided in StringExtensions.swift to convert StringIndex and StringRange instances between strings. Also, if you create a StringIndex or StringRange on a String and then mutate that string, the existing StringIndex or StringRange instances should be considered invalid for the mutated String.

```swift
let string = "🐺❤️🇺🇸"
print("string has \(string.characters.count) extended grapheme clusters.")
print("As an NSString, string has \((string as NSString).length) UTF-16 words.")
let start = string.startIndex.advancedBy(1)
let end = start.advancedBy(2)
let range = start..<end
print(string.substringWithRange(range))
```

Prints:

```
string has 3 extended grapheme clusters.
As an NSString, string has 8 UTF-16 words.
❤️🇺🇸
```

On the rare occasions you need to use literal integer offsets, you could just write:
let range = string.range(start: 1, end: 3)

...or to create a range that covers the whole String:
let range = string.range

...or to create a range that represents an insertion point:
let index = string.index(start: 2)


On the rare occasions you need to convert a Swift StringRange to an NSRange or vice-versa:

let nsRange = string.nsRange(from: range)

let range = string.range(from: nsRage)


On the rare occasions you need to convert a Swift StringIndex to an NSRange.location:

let location = string.location(fromIndex: stringIndex)

let index = string.index(fromLocation: location)

## Strings

## Attributed Strings

*** Only one type of attributed string: AttributedString.

public typealias AttributedString = NSMutableAttributedString

The § postfix operator can be used to convert any Swift String, NSString, or NSAttributedString into an AttributedString, so it can be manipulated further.

Applying the § postfix operator to an existing AttributedString makes a separate copy of it.

This converts a straight Swift string to an AttributedString

   func example() -> AttributedString {
       let string = "The quick brown fox."
       let attributedString = string§
       return attributedString
   }

This retrieves the NSAttributedString from a UITextView and converts it to an AttributedString

   func example(textView: UITextView) -> AttributedString {
       let string = textView.attributedText  // This is an NSAttributedString
       let attributedString = string§        // This is an AttributedString (NSMutableAttributedString)
       return attributedString
   }

This performs localization with placeholder replacement using the ¶ operator (see StringExtensions.swift), then uses the § operator to convert the result to an AttributedString.

   func example() -> AttributedString {
       let followersCount = 20
       let template = "#{followersCount} followers." ¶ ["followersCount": followersCount]
       return template§
   }

   func example() {
       let s1 = "Hello."§ // Creates an AttributedString
       s1.foregroundColor = .red // s1 is now red

       let s2 = s1 // Only copies the reference
       s2.foregroundColor = .green // s1 and s2 are now green

       let s3 = s1§ // This performs a true copy of s1

       s3.foregroundColor = .blue // s1 and s2 are green, s3 is blue.
   }





existing method: (DON'T USE)

public func removeAttribute(name: String, range: NSRange)


new method:

public func remove(attributeNamed: String, fromRange: StringRange? = nil)


   func example(s: AttributedString) {
       s.remove(attributeNamed: NSAttributedStringKey.font.rawValue) // removes attribute from entire string
       let range = s.string.range(start: 0, end: 2)
       s.remove(attributeNamed: NSAttributedStringKey.font.rawValue, fromRange: range) // removes attribute from just `range`.
   }



*** Attributes are added to AttributedString instances by assignment.

Common attributes such as font, foregroundColor, and paragraphStyle can be directly assigned as attributes.

   func example() {
       let attributedString = "The quick brown fox."§
       attributedString.font = .boldSystemFont(ofSize: 18)
       attributedString.foregroundColor = .red
   }



*** Attributes of substrings of AttributedString instances are edited together.

   func testString() {
       let attributedString = "The quick brown fox."§
       attributedString.font = .systemFont(ofSize: 18) // Applies to whole string
       attributedString.foregroundColor = .gray

       let range = attributedString.string.range(start: 10, end: 15) // "brown"
       attributedString.edit(in: range) { substring in
           substring.font = .boldSystemFont(ofSize: 18)
           substring.foregroundColor = .red
           // The word "brown" is now bold and red.
       }

       attributedString.printAttributes()
   }

Prints:
Note: "NSFont" and "NSColor" are the attribute names, and correspond to NSAttributedStringKey.font.rawValue and NSAttributedStringKey.foregroundColor.rawValue.

   T NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   h NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   e NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
     NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   q NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   u NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   i NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   c NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   k NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
     NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   b NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
   r NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
   o NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
   w NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
   n NSFont:(0x02 Font ".SF UI Text" bold 18.0) NSColor:(0x03 Color (red))
     NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   f NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   o NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   x NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))
   . NSFont:(0x00 Font ".SF UI Text" 18.0) NSColor:(0x01 Color (gray))



*** User-defined attributes are added, accessed, and removed by subscripting. Remove an attribute by assigning nil.

   func example() {
       let attributedString = "The quick brown fox."§
       let range = attributedString.string.range(start: 10, end: 15) // "brown"
       let key = "myAttribute"

       attributedString.edit(in: range) { substring in
           // Assigns attribute to entire substring.
           substring[key] = CGFloat(20.5)

           // Retrieves value from first character of substring.
           let value = substring[key] as! CGFloat
           print(value) // prints "20.5"
       }

       attributedString.printAttributes()
   }

Prints:

   20.5
   T
   h
   e

   q
   u
   i
   c
   k

   b myAttribute:(0x00 25.5)
   r myAttribute:(0x00 25.5)
   o myAttribute:(0x00 25.5)
   w myAttribute:(0x00 25.5)
   n myAttribute:(0x00 25.5)

   f
   o
   x
   .



*** "Tags" are user-defined attributes that always have type `Bool` and are always `true`.

   func example() {
       let attributedString = "The quick brown fox."§

       let range1 = attributedString.string.range(start: 0, end: 3) // "The"
       let key1 = "foo"
       attributedString.edit(in: range1) { substring in
           substring[key1] = CGFloat(25.5)
       }

       let range = attributedString.string.range(start: 10, end: 15) // "brown"
       let key = "link"
       attributedString.edit(in: range) { substring in
           substring.addTag(key)
       }

       attributedString.printAttributes()
   }

Prints:

   T foo:(0x00 25.5)
   h foo:(0x00 25.5)
   e foo:(0x00 25.5)

   q
   u
   i
   c
   k

   b link:(0x01 true)
   r link:(0x01 true)
   o link:(0x01 true)
   w link:(0x01 true)
   n link:(0x01 true)

   f
   o
   x
   .



*** Tags and other attributes associated with those tags can be created from "template" strings.

A template string example:

The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}.

Substrings of the form #{text|tag} can be created using a String convenience constructor:

   func example() {
       let string = String(text: "the lazy dog", tag: "subject")
       print(string)
   }

Prints:

#{the lazy dog|subject}


Once a template String has been constructed, use String.attributedStringWithTags() to convert it to an AttributedString:

   func example() {
       let template = "The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}."
       let attributedString = template.attributedStringWithTags()
       attributedString.printAttributes()
   }

Prints:

   T
   h
   e

   q
   u
   i
   c
   k

   b color:(0x00 true)
   r color:(0x00 true)
   o color:(0x00 true)
   w color:(0x00 true)
   n color:(0x00 true)

   f
   o
   x

   j action:(0x00 true)
   u action:(0x00 true)
   m action:(0x00 true)
   p action:(0x00 true)
   s action:(0x00 true)

   o
   v
   e
   r

   t subject:(0x00 true)
   h subject:(0x00 true)
   e subject:(0x00 true)
     subject:(0x00 true)
   l subject:(0x00 true)
   a subject:(0x00 true)
   z subject:(0x00 true)
   y subject:(0x00 true)
     subject:(0x00 true)
   d subject:(0x00 true)
   o subject:(0x00 true)
   g subject:(0x00 true)
   .

Provide a closure to add additional attributes to each tag, or the string as a whole *before* each tag is added. The closure is called once with an empty string tag and a substring encompassing the entire string *before* it is called for each tag, allowing default attributes to be set that will be overridden by the tags.

   func example() {
       let template = "The quick #{brown|color} fox #{jumps|action} over #{the lazy dog|subject}."
       let attrString = template.attributedStringWithTags() { (tag, substring) in
           switch tag {
           case "color":
               substring.foregroundColor = .brown
           case "action":
               substring.foregroundColor = .red
           case "subject":
               substring.foregroundColor = .gray
           default:
               // The default clause is called *before* the tag-specific clauses.
               substring.foregroundColor = .white
               substring.font = .systemFont(ofSize: 12)
               break
           }
       }
       attrString.printAttributes()
   }

Prints:

   T NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   h NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   e NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   q NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   u NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   i NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   c NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   k NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   b color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   r color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   o color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   w color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   n color:(0x02 true) NSColor:(0x03 Color (r:0.60 g:0.40 b:0.20)) NSFont:(0x00 Font ".SF UI Text" 12.0)
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   f NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   o NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   x NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   j action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   u action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   m action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   p action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   s action:(0x02 true) NSColor:(0x04 Color (red)) NSFont:(0x00 Font ".SF UI Text" 12.0)
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   o NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   v NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   e NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   r NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
     NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))
   t subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   h subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   e subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
     subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   l subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   a subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   z subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   y subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
     subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   d subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   o subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   g subject:(0x02 true) NSColor:(0x05 Color (gray)) NSFont:(0x00 Font ".SF UI Text" 12.0)
   . NSFont:(0x00 Font ".SF UI Text" 12.0) NSColor:(0x01 Color (white))

   class MyTableViewCell: TableViewCell {
       @IBOutlet weak var textView: TextView!

       private let linkTag = "link"

       override func awakeFromNib() {
           super.awakeFromNib()

           setupText()
           setupTapActions()
       }

       private func setupText() {
           let fontSize: CGFloat = 11
           let link1Template = String(text: "http://google.com", tag: "link")
           let link2Template = String(text: "http://bing.com", tag: "link")
           let text = "To perform a search, visit \(link1Template) or \(link2Template)"
           let attributedText = text.attributedStringWithTags() { (tag, substring) in
               switch tag {
               case self.linkTag:
                   substring.font = .boldSystemFont(ofSize: fontSize)
                   substring.foregroundColor = .blue
               default:
                   substring.font = .systemFont(ofSize: fontSize)
                   substring.foregroundColor = .white
               }
           }
           textView.attributedText = attributedText
       }

       private func setupTapActions() {
           textView.setTapAction(forTag: linkTag) { [unowned self] urlText in
               print("url tapped: \(urlText)")
           }
       }
   }
