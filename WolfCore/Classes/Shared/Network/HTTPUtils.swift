//
//  HTTPUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 WolfMcNally.com.
//

import Foundation
import WolfPipe
import ExtensibleEnumeratedName
import WolfLog

public enum HTTPUtilsError: Error {
    case expectedJSONDict
    case expectedImage
}

public struct HTTPScheme: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension HTTPScheme {
    public static let http = HTTPScheme("http")
    public static let https = HTTPScheme("https")
}

public struct HTTPMethod: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension HTTPMethod {
    public static let get = HTTPMethod("GET")
    public static let post = HTTPMethod("POST")
    public static let patch = HTTPMethod("PATCH")
    public static let head = HTTPMethod("HEAD")
    public static let options = HTTPMethod("OPTIONS")
    public static let put = HTTPMethod("PUT")
    public static let delete = HTTPMethod("DELETE")
    public static let trace = HTTPMethod("TRACE")
    public static let connect = HTTPMethod("CONNECT")
}

public struct ContentType: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension ContentType {
    public static let json = ContentType("application/json")
    public static let jpg = ContentType("image/jpeg")
    public static let png = ContentType("image/png")
    public static let gif = ContentType("image/gif")
    public static let html = ContentType("text/html")
    public static let txt = ContentType("text/plain")
    public static let pdf = ContentType("application/pdf")
    public static let mp4 = ContentType("video/mp4")
    public static let vcard = ContentType("text/vcard")
}

// See also: https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html#//apple_ref/doc/uid/TP40001319-CH201-SW1
public struct UniformTypeIdentifier: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

// See also: https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259-SW1
extension UniformTypeIdentifier {
    // There is no UTI for JSON
    public static let jpg = UniformTypeIdentifier("public.jpeg")
    public static let png = UniformTypeIdentifier("public.png")
    public static let gif = UniformTypeIdentifier("com.compuserve.gif")
    public static let html = UniformTypeIdentifier("public.html")
    public static let txt = UniformTypeIdentifier("public.plain-text")
    public static let pdf = UniformTypeIdentifier("com.adobe.pdf")
    public static let mp4 = UniformTypeIdentifier("public.mpeg-4")
    public static let vcard = UniformTypeIdentifier("public.vcard")
}

public struct Charset: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension Charset {
    public static let utf8 = Charset("utf-8")
}

public struct HeaderField: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension HeaderField {
    public static let accept = HeaderField("Accept")
    public static let contentType = HeaderField("Content-Type")
    public static let encoding = HeaderField("Encoding")
    public static let connection = HeaderField("Connection")
    public static let authorization = HeaderField("Authorization")
    public static let contentRange = HeaderField("Content-Range")
    public static let uploadToken = HeaderField("Upload-Token")
    public static let contentLength = HeaderField("Content-Length")
    public static let clientRequestID = HeaderField("X-Client-Request-ID")
    public static let awsRequestID = HeaderField("x-amzn-RequestId")
}

public struct StatusCode: ExtensibleEnumeratedName {
    public let rawValue: Int

    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: Int) { self.init(rawValue) }
}

extension StatusCode {
    public static let ok = StatusCode(200)
    public static let created = StatusCode(201)
    public static let accepted = StatusCode(202)
    public static let noContent = StatusCode(204)

    public static let badRequest = StatusCode(400)
    public static let unauthorized = StatusCode(401)
    public static let forbidden = StatusCode(403)
    public static let notFound = StatusCode(404)
    public static let conflict = StatusCode(409)
    public static let tooManyRequests = StatusCode(429)

    public static let internalServerError = StatusCode(500)
    public static let notImplemented = StatusCode(501)
    public static let badGateway = StatusCode(502)
    public static let serviceUnavailable = StatusCode(503)
    public static let gatewayTimeout = StatusCode(504)
}

public struct ConnectionType: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init?(rawValue: String) { self.init(rawValue) }
}

extension ConnectionType {
    public static let close = ConnectionType("close")
    public static let keepAlive = ConnectionType("keep-alive")
}

public class HTTP {
    public static func retrieveData(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, name: String? = nil) -> DataPromise {

        let name = name ?? request.name
        let token: InFlightToken! = inFlightTracker?.start(withName: name)

        func onComplete(promise: DataPromise, task: Cancelable?, error: Error?, response: URLResponse?, data: Data?) {
            guard error == nil else {
                switch error {
                case let error as DescriptiveError:
                    if error.isCancelled {
                        inFlightTracker?.end(withToken: token, result: Result<Void>.canceled)
                        logTrace("\(token!) retrieveData was cancelled")
                    }
                    dispatchOnMain {
                        promise.fail(error)
                    }
                default:
                    inFlightTracker?.end(withToken: token, result: Result<Error>.failure(error!))
                    logError("\(token!) retrieveData returned error")

                    dispatchOnMain {
                        promise.fail(error!)
                    }
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("\(token!) improper response type: \(response†)")
            }

            guard data != nil else {
                let error = HTTPError(request: request, response: httpResponse)

                inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))
                logError("\(token!) No data returned")

                dispatchOnMain {
                    promise.fail(error)
                }
                return
            }

            guard let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)

                inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))
                logError("\(token!) Unknown response code: \(httpResponse.statusCode)")

                dispatchOnMain {
                    promise.fail(error)
                }
                return
            }

            guard successStatusCodes.contains(statusCode) else {
                let error = HTTPError(request: request, response: httpResponse, data: data)

                inFlightTracker?.end(withToken: token, result: Result<HTTPError>.failure(error))

                if !expectedFailureStatusCodes.contains(statusCode) {
                    logError("\(token!) Failure response code: \(statusCode)")
                }

                dispatchOnMain {
                    promise.fail(error)
                }
                return
            }

            inFlightTracker?.end(withToken: token, result: Result<HTTPURLResponse>.success(httpResponse))

            let inFlightData = data!
            dispatchOnMain {
                promise.task = task
                promise.keep(inFlightData)
            }
        }

        func perform(promise: DataPromise) {
            let _sessionActions = HTTPActions()

            _sessionActions.didReceiveResponse = { (sessionActions, session, dataTask, response, completionHandler) in
                completionHandler(.allow)
            }

            _sessionActions.didComplete = { (sessionActions, session, task, error) in
                onComplete(promise: promise, task: task, error: error, response: sessionActions.response, data: sessionActions.data)
            }

            let sharedSession = URLSession.shared
            let config = sharedSession.configuration.copy() as! URLSessionConfiguration
            let session = URLSession(configuration: config, delegate: _sessionActions, delegateQueue: nil)
            let task = session.dataTask(with: request)
            promise.task = session.dataTask(with: request)
            task.resume()
        }

        func mockPerform(promise: DataPromise) {
            let mock = mock!
            dispatchOnBackground(afterDelay: mock.delay) {
                dispatchOnMain {
                    let response = HTTPURLResponse(url: request.url!, statusCode: mock.statusCode.rawValue, httpVersion: nil, headerFields: nil)!
                    var error: Error?
                    if !successStatusCodes.contains(mock.statusCode) {
                        error = HTTPError(request: request, response: response)
                    }
                    onComplete(promise: promise, task: nil, error: error, response: response, data: mock.data)
                }
            }
        }

        if mock != nil {
            return DataPromise(with: mockPerform)
        } else {
            return DataPromise(with: perform)
        }
    }


    public static func retrieve(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, name: String? = nil) -> SuccessPromise {
        return retrieveData(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock, name: name).then { _ in }
    }

    
    public static func retrieveJSON(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, name: String? = nil) -> JSONPromise {
        var request = request
        request.setAcceptContentType(.json)

        return retrieveData(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock, name: name).then { data in
            return try data |> JSON.init
        }
    }


    public static func retrieveJSONDictionary(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, name: String? = nil) -> JSONPromise {
        return retrieveJSON(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock, name: name).then { json in
            guard json.value is JSON.Dictionary else {
                throw HTTPUtilsError.expectedJSONDict
            }
            return json
        }
    }


    //    #if !os(Linux)
    //    public static func retrieveImage(with request: URLRequest, successStatusCodes: [StatusCode] = [.ok], expectedFailureStatusCodes: [StatusCode] = [], mock: Mock? = nil, name: String? = nil) -> ImagePromise {
    //        return retrieveData(with: request, successStatusCodes: successStatusCodes, expectedFailureStatusCodes: expectedFailureStatusCodes, mock: mock, name: name).then { data in
    //            guard let image = OSImage(data: data) else {
    //                throw HTTPUtilsError.expectedImage
    //            }
    //            return image
    //        }
    //    }
    //    #endif
}

extension URLSessionTask: Cancelable {
    public var isCanceled: Bool { return false }
}

extension URLRequest {
    public func value(for headerField: HeaderField) -> String? {
        return value(forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func setMethod(_ method: HTTPMethod) {
        httpMethod = method.rawValue
    }

    public mutating func setValue(_ value: String?, for headerField: HeaderField) {
        setValue(value, forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func addValue(_ value: String, for headerField: HeaderField) {
        addValue(value, forHTTPHeaderField: headerField.rawValue)
    }

    public mutating func setAcceptContentType(_ contentType: ContentType) {
        setValue(contentType.rawValue, for: .accept)
    }

    public mutating func setContentType(_ contentType: ContentType, charset: Charset? = nil) {
        if let charset = charset {
            setValue("\(contentType.rawValue); charset=\(charset.rawValue)", for: .contentType)
        } else {
            setValue(contentType.rawValue, for: .contentType)
        }
    }

    public mutating func setContentTypeJSON() {
        setValue("\(ContentType.json.rawValue); charset=utf-8", for: .contentType)
    }

    public mutating func setContentLength(_ length: Int) {
        setValue(String(length), for: .contentLength)
    }

    public mutating func setConnection(_ connection: ConnectionType) {
        setValue(connection.rawValue, for: .connection)
    }

    public mutating func setAuthorization(_ value: String) {
        setValue(value, for: .authorization)
    }

    public mutating func setClientRequestID() {
        setValue(UniqueID() |> String.init, for: .clientRequestID)
    }

    public var name: String {
        var name = [String]()
        name.append(httpMethod†)
        if let url = self.url {
            name.append(url.path)
        }
        return name.joined(separator: " ")
    }
}

extension HTTPURLResponse {
    public func value(for headerField: HeaderField) -> String? {
        return allHeaderFields[headerField.rawValue] as? String
    }
}
