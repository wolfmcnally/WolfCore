//
//  StringLocalization.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension LogGroup {
    public static let localization = LogGroup("localization")
}

private var _localizationTableNames = [String?]()
public var localizationTableNames = [String]() {
    didSet {
        _localizationTableNames = []
        localizationTableNames.forEach { _localizationTableNames.append($0) }
        _localizationTableNames.append(nil)
    }
}

public struct StringName: ExtensibleEnumeratedName, Reference {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }

    // Reference
    public var referent: String {
        return rawValue¶
    }
}

public postfix func ® (lhs: StringName) -> String {
    return lhs.referent
}

public var localizationBundles = [Bundle.main]

extension String {
    public func localized(onlyIfTagged mustHaveTag: Bool = false, inLanguage language: String? = nil, replacingPlaceholdersWithReplacements replacements: Replacements? = nil) -> String {
        let untaggedKey: String
        let taggedKey: String
        let hasTag: Bool
        if self.hasSuffix("¶") {
            untaggedKey = String(self[ ..<self.index(self.endIndex, offsetBy: -1)])
            taggedKey = self
            hasTag = true
        } else {
            untaggedKey = self
            taggedKey = self + "¶"
            hasTag = false
        }

        guard !mustHaveTag || hasTag else { return self }

        var s: String?
        for bundle in localizationBundles {
            s = localized(key: taggedKey, in: bundle, inLanguage: language)
            if s != nil { break }
        }

        if s == nil {
            logWarning("No localization found for: \"\(taggedKey)\".", group: .localization)
            s = untaggedKey
        }

        if let replacements = replacements {
            s = s!.replacingPlaceholders(with: replacements)
        }

        return s!
    }

    private func localized(key: String, in bundle: Bundle, inLanguage language: String?) -> String? {
        var bundle = bundle

        if let language = language {
            if let path = bundle.path(forResource: language, ofType: "lproj") {
                if let langBundle = Bundle(path: path) {
                    bundle = langBundle
                }
            }
        }

        var localized: String?
        let notFoundValue = "⁉️"
        for tableName in _localizationTableNames {
            let s = bundle.localizedString(forKey: key, value: notFoundValue, table: tableName)
            if s != notFoundValue {
                localized = s
                break
            }
        }

        return localized
    }
}
