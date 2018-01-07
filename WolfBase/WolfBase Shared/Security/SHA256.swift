//
//  SHA256.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

#if os(Linux)
    import COpenSSL
#else
    import CommonCrypto
#endif

public struct SHA256 {
    private typealias `Self` = SHA256
    
    #if os(Linux)
    private static let digestLength = Int(SHA256_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
    #endif
    
    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)
    
    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                    _ = COpenSSL.SHA256(dataPtr, data.count, digestPtr)
                #else
                    CC_SHA256(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }
    
    public static func test() {
        // $ openssl dgst -sha256 -hex
        // The quick brown fox\n^d
        // 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let data = "The quick brown fox\n" |> Data.init
        let sha256 = data |> SHA256.init
        print(sha256)
        // prints 35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
        let string = sha256 |> String.init
        print(string == "35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8")
        // prints true
    }
}

extension SHA256: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(sha256: SHA256) {
        self.init(sha256.description)
    }
}
