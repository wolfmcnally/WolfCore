//
//  Authorization.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/3/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol AuthorizationProtocol: Codable {
    // Implemented by conforming types.
    static var currentVersion: Int { get }
    static var keychainIdentifier: String { get }
    var savedVersion: Int { get }
    var authorizationToken: String { get set }

    // Implemented in extension below.
    func save()
    static func load() -> Self?
    static func delete()
}

extension AuthorizationProtocol {
    public func save() {
        try! KeyChain.updateObject(self, for: Self.keychainIdentifier)
    }

    public static func load() -> Self? {
        return try! KeyChain.object(Self.self, for: Self.keychainIdentifier)
    }

    public static func delete() {
        do {
            try KeyChain.delete(key: keychainIdentifier)
        } catch {
            // Do nothing
        }
    }
}

public struct Authorization: AuthorizationProtocol {
    public static let currentVersion = 1
    public static let keychainIdentifier = "authorization"
    public var savedVersion = 1
    public var authorizationToken: String
    public var credentials: Credentials

    public var id: String {
        return credentials.id
    }
}

public struct APIKey: AuthorizationProtocol {
    public static var currentVersion: Int = 1
    public static var keychainIdentifier: String { fatalError("not implemented") }
    public var savedVersion: Int = 1
    public var authorizationToken: String

    public init(authorizationToken: String) {
        self.authorizationToken = authorizationToken
    }

    public func save() { }
    public static func load() -> APIKey? { return nil }
    public static func delete() { }
}
