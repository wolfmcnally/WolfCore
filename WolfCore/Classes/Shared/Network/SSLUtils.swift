//
//  SSLUtils.swift
//  WolfCore
//
//  Created by Robert McNally on 2/1/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if os(Linux)
    import Glibc
    import COpenSSL
let OPENSSL_free = CRYPTO_free
    typealias SSLContextRef = UnsafeMutablePointer<SSL_CTX>
    typealias HostEntRef = UnsafeMutablePointer<hostent>?
#endif

public struct SSLError: Error, CustomStringConvertible {
    public let message: String
    public let code: Int?

    public init(message: String, code: Int? = nil) {
        self.message = message
        self.code = code
    }

    public var description: String {
        var c = [message]
        if let code = code {
            c.append("[\(code)]")
        }

        return "SSLError(\(c.joined(separator: " ")))"
    }

    #if os(Linux)
    public static func checkNotNil<T>(_ value: UnsafeMutablePointer<T>?, message: String) throws -> UnsafeMutablePointer<T> {
    if value != nil {
    return value!
    } else {
    let code = Int(ERR_get_error())
    throw CryptoError(message: message, code: code)
    }
    }

    public static func checkCode(ret: Int32, message: String) throws {
    if ret != 1 {
    let code = Int(ERR_get_error())
    throw CryptoError(message: message, code: code)
    }
    }
    #endif
}

public class SSL {
    #if os(Linux)
    private static var context: SSLContextRef! = nil
    #endif

    public static func setup() throws {
        #if os(Linux)
            guard context == nil else { return }

            SSL_library_init()
            OPENSSL_add_all_algorithms_conf()
            OPENSSL_config(nil)
            SSL_load_error_strings()

            let method = SSLv3_client_method()
            context = try SSLError.checkNotNil(SSL_CTX_new(method), message: "Creating SSL context.")
        #endif
    }

    public class Connection {
        private let hostname: String
        private let port: Int

        public init(hostname: String, port: Int) {
            self.hostname = hostname
            self.port = port
        }

        public func open() throws {
            // let host: HostEntRef = try SSLError.checkNotNil(gethostbyname(hostname), message: "Getting host from hostname.")
            // let h: hostent = host.memory
            // let h2: Int = h.h_addr_list
            // print(h.h_addr_list)
        }
    }
}
