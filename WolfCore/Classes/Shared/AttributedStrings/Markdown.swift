//
//  Markdown.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/29/18.
//

extension NSAttributedString.Key {
    static let markdownBold = NSAttributedString.Key(rawValue: "markdownBold")
    static let markdownItalic = NSAttributedString.Key(rawValue: "markdownItalic")
    static let markdownStrikethrough = NSAttributedString.Key(rawValue: "markdownStrikethrough")
}

extension AttributedString {
    private typealias `Self` = AttributedString

    // Text surrounded by **double asterisks** or __double underscores__.
    // (?:\*\*|__)(.*?)(?:\*\*|__)
    private static let boldRegex = try! NSRegularExpression(pattern: "(?:\\*\\*|__)(.*?)(?:\\*\\*|__)", options: [.dotMatchesLineSeparators])

    // Text surrounded by *single asterisks* or _single underscores_.
    // (?:\*|_)(.*?)(?:\*|_)
    private static let italicRegex = try! NSRegularExpression(pattern: "(?:\\*|_)(.*?)(?:\\*|_)", options: [.dotMatchesLineSeparators])

    // Text surrounded by ~~double tildes~~.
    // ~~(.*?)~~
    private static let strikethroughRegex = try! NSRegularExpression(pattern: "~~(.*?)~~", options: [.dotMatchesLineSeparators])

    //        let text = """
    //    Emphasis, aka italics, with *single asterisks* or _single underscores_.
    //
    //    Strong emphasis, aka bold, with **double asterisks** or __double underscores__.
    //
    //    Combined emphasis with **bold with double asterisks and _bold-italic with single underscores_**.
    //
    //    Strikethrough uses two tildes. ~~**Scratch** this.~~
    //    """

    public func applyMarkdownEmphasis() {
        func replaceMatches(for regex: NSRegularExpression, adding attribute: NSAttributedString.Key) {
            let matches = regex.matches(in: string, options: [], range: string.nsRange)

            let attributes: StringAttributes = [
                attribute: true
            ]

            for match in matches.reversed() {
                let replaceRange = match.range(atIndex: 0, inString: string)
                let captureRange = match.range(atIndex: 1, inString: string)
                let capturedString = attributedSubstring(from: captureRange)
                capturedString.addAttributes(attributes)
                replaceCharacters(in: replaceRange, with: capturedString)
            }
        }

        replaceMatches(for: Self.boldRegex, adding: .markdownBold)
        replaceMatches(for: Self.italicRegex, adding: .markdownItalic)
        replaceMatches(for: Self.strikethroughRegex, adding: .markdownStrikethrough)

        enumerateAttributes { (attributes, range, substring) -> Bool in
            var traits = OSFontDescriptorSymbolicTraits()
            if attributes[.markdownBold] != nil {
                traits.insertBold()
                substring.removeAttribute(.markdownBold)
            }
            if attributes[.markdownItalic] != nil {
                traits.insertItalic()
                substring.removeAttribute(.markdownItalic)
            }
            if attributes[.markdownStrikethrough] != nil {
                substring.removeAttribute(.markdownStrikethrough)
                substring.addAttributes([
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                    ])
            }
            let font = attributes[.font] as! OSFont
            let descriptor = font.fontDescriptor.makeWithSymbolicTraits(traits)
            let newFont = OSFont.makeWithDescriptor(descriptor)
            substring.font = newFont

            return false
        }
    }
}
