//
//  Authorization.swift
//  WolfBase
//
//  Created by Wolf McNally on 3/3/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol AuthorizationProtocol: JSONModel {
  // Implmented by conforming types.
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
    try! KeyChain.update(json: json, for: Self.keychainIdentifier)
  }
  
  public static func load() -> Self? {
    guard let json = try! KeyChain.json(for: Self.keychainIdentifier) else { return nil }
    return Self(json: json)
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
  private typealias `Self` = Authorization
  
  public static let currentVersion = 1
  public static let keychainIdentifier = "authorization"
  
  public var json: JSON
  
  private static let versionKey = "version"
  private static let credentialsTypeKey = "credentialsType"
  
  private static let authorizationTokenKey = "authorizationToken"
  
  private static let credentialsIDKey = "credentialsID"
  private static let credentialsTokenKey = "credentialsToken"
  
  public init(credentials: Credentials, authorizationToken: String) {
    let json = JSON([
      Self.versionKey: Self.currentVersion,
      Self.credentialsTypeKey: credentials.type,
      Self.authorizationTokenKey: authorizationToken,
      Self.credentialsIDKey: credentials.id,
      Self.credentialsTokenKey: credentials.token
      ])
    
    self.init(json: json)
  }
  
  public init(json: JSON) {
    self.json = json
  }
  
  public var savedVersion: Int { return try! json.getValue(for: Self.versionKey) }
  
  public var credentials: Credentials {
    let credentialsTypeString: String = try! json.getValue(for: Self.credentialsTypeKey)
    switch credentialsTypeString {
    case CredentialsType.username.rawValue:
      return Credentials(username: credentialsID, password: credentialsToken)
    case CredentialsType.email.rawValue:
      return Credentials(email: credentialsID, password: credentialsToken)
    case CredentialsType.facebook.rawValue:
      return Credentials(facebookID: credentialsID, token: credentialsToken)
    case CredentialsType.instagram.rawValue:
      return Credentials(instagramID: credentialsID, token: credentialsToken)
    default:
      fatalError()
    }
  }
  
  public var id: String {
    return credentials.id
  }
  
  private var credentialsID: String { return try! json.getValue(for: Self.credentialsIDKey) }
  private var credentialsToken: String { return try! json.getValue(for: Self.credentialsTokenKey) }
  
  public var authorizationToken: String {
    get {
      return try! json.getValue(for: Self.authorizationTokenKey)
    }
    
    set {
      json.setValue(newValue, for: Self.authorizationTokenKey)
    }
  }
}
