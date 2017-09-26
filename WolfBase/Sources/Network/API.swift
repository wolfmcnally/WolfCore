//
//  API.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension Notification.Name {
  public static let loggedOut = Notification.Name("loggedOut")
}

open class API<T: AuthorizationProtocol> {
  public typealias AuthorizationType = T
  
  private let endpoint: Endpoint
  private let authorizationHeaderField: HeaderField
  
  public var debugPrintRequests = false
  
  public var authorization: AuthorizationType? {
    didSet {
      if authorization != nil {
        authorization!.save()
      } else {
        AuthorizationType.delete()
      }
    }
  }
  
  public init(endpoint: Endpoint, authorizationHeaderField: HeaderField = .authorization) {
    self.endpoint = endpoint
    self.authorizationHeaderField = authorizationHeaderField
    guard let authorization = AuthorizationType.load(), authorization.savedVersion == AuthorizationType.currentVersion else { return }
    self.authorization = authorization
  }
  
  public var hasCredentials: Bool {
    return authorization != nil
  }
  
  public enum Error: Swift.Error {
    case credentialsRequired
  }
  
  public var authorizationToken: String {
    get {
      return authorization!.authorizationToken
    }
    
    set {
      authorization!.authorizationToken = newValue
    }
  }
  
  public func newRequest(method: HTTPMethod, path: [Any]? = nil, query: [String : String]? = nil, isAuth: Bool, body json: JSON? = nil) throws -> URLRequest {
    guard !isAuth || authorization != nil else {
      throw Error.credentialsRequired
    }
    
    let url = URL(scheme: HTTPScheme.https, host: endpoint.host, basePath: endpoint.basePath, pathComponents: path, query: query)
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.setClientRequestID()
    request.setMethod(method)
    request.setConnection(.close)
    if let json = json {
      request.httpBody = json.data
      request.setContentType(.json, charset: .utf8)
      request.setContentLength(json.data.count)
    }
    if isAuth {
      request.setValue(authorizationToken, for: authorizationHeaderField)
    }
    
    if debugPrintRequests {
      request.printRequest()
    }
    
    return request
  }
  
  public func newPromise<T>(method: HTTPMethod, path: [Any]? = nil, query: [String : String]? = nil, isAuth: Bool = false, body json: JSON? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, with f: @escaping (JSON) throws -> T) -> Promise<T> {
    do {
      let request = try self.newRequest(method: method, path: path, query: query, isAuth: isAuth, body: json)
      return HTTP.retrieveJSON(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).then { json in
        return try f(json)
        }.recover { (error, promise) in
          self.handle(error: error, promise: promise)
      }
    } catch let error {
      return Promise<T>(error: error)
    }
  }

  public func newPromise<T: Decodable>(method: HTTPMethod, path: [Any]? = nil, query: [String : String]? = nil, isAuth: Bool = false, body json: JSON? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> Promise<T> {
    do {
      let request = try self.newRequest(method: method, path: path, query: query, isAuth: isAuth, body: json)
      return HTTP.retrieveData(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).then { data in
        return try JSONDecoder().decode(T.self, from: data)
        }.recover { (error, promise) in
          self.handle(error: error, promise: promise)
      }
    } catch let error {
      return Promise<T>(error: error)
    }
  }

  public func newPromise(method: HTTPMethod, path: [Any]? = nil, isAuth: Bool = false, body json: JSON? = nil, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil) -> SuccessPromise {
    do {
      let request = try self.newRequest(method: method, path: path, isAuth: isAuth, body: json)
      return HTTP.retrieve(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock).succeed().recover { (error, promise) in
        self.handle(error: error, promise: promise)
      }
    } catch let error {
      return SuccessPromise(error: error)
    }
  }
  
  private func handle<T>(error: Swift.Error, promise: Promise<T>) {
    if error.httpStatusCode == .unauthorized {
      promise.cancel()
      logout()
    } else {
      promise.fail(error)
    }
  }
  
  public func logout() {
    authorization = nil
    notificationCenter.post(name: .loggedOut, object: self)
  }
}
