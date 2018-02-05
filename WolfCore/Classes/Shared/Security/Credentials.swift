//
//  Credentials.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public typealias CredentialsPromise = Promise<Credentials>

public enum CredentialsType: String, JSONRepresentable {
    case username = "username"
    case email = "email"
    case facebook = "facebook"
    case instagram = "instagram"
    
    public var json: JSON {
        return JSON(rawValue)
    }
}

public struct Credentials {
    public let type: CredentialsType
    public let id: String
    public let token: String
    
    public init(username: String, password: String) {
        type = .username
        id = username
        token = password
    }
    
    public init(email: String, password: String) {
        type = .email
        id = email
        token = password
    }
    
    public init(facebookID: String, token: String) {
        type = .facebook
        id = facebookID
        self.token = token
    }
    
    public init(instagramID: String, token: String) {
        type = .instagram
        id = instagramID
        self.token = token
    }
}
