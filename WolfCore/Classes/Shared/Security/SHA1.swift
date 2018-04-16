//
//  SHA1.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if canImport(COpenSSL)
    import COpenSSL
#elseif canImport(CommonCryptoModule)
    import CommonCryptoModule
#endif

public struct SHA1 {
    private typealias `Self` = SHA1

    #if os(Linux)
    private static let digestLength = Int(SHA_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
    #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                    _ = COpenSSL.SHA1(dataPtr, data.count, digestPtr)
                #else
                    CC_SHA1(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }

    public static func test() {
        // $ openssl dgst -sha1 -hex
        // The quick brown fox\n^d
        // 16d17cfbec56708a1174c123853ad609a7e67cd8
        let data = "The quick brown fox\n" |> Data.init
        let sha1 = data |> SHA1.init
        print(sha1)
        // prints 16d17cfbec56708a1174c123853ad609a7e67cd8
        let string = sha1 |> String.init
        print(string == "16d17cfbec56708a1174c123853ad609a7e67cd8")
        // prints true
    }
}

extension SHA1: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(sha1: SHA1) {
        self.init(sha1.description)
    }
}
