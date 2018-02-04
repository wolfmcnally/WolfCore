//
//  HMACSHA256.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if os(Linux)
    import COpenSSL
#else
    import CommonCryptoModule
#endif

public struct HMACSHA256 {
    private typealias `Self` = HMACSHA256
    
    #if os(Linux)
    private static let digestLength = Int(SHA256_DIGEST_LENGTH)
    #else
    private static let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
    #endif
    
    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)
    
    public init(data: Data, key: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                key.withUnsafeBytes { (keyPtr: UnsafePointer<UInt8>) in
                    #if os(Linux)
                        _ = HMAC(EVP_sha256(), keyPtr, Int32(key.count), dataPtr, data.count, digestPtr, nil)
                    #else
                        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyPtr, key.count, dataPtr, data.count, digestPtr)
                    #endif
                }
            }
        }
    }
    
    public static func test() {
        // $ openssl dgst -sha256 -hmac "secret"
        // The quick brown fox\n^d
        // 243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb
        let data = "The quick brown fox\n" |> Data.init
        let key = "secret" |> Data.init
        let hmac = (data, key) |> HMACSHA256.init
        print(hmac)
        // prints 243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb
        let string = hmac |> String.init
        print(string == "243d36ba44bbccad32ea644a4501cd62d425521165211ec86d55d91dc32c50fb")
        // prints true
    }
}

extension HMACSHA256: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(hmacsha256: HMACSHA256) {
        self.init(hmacsha256.description)
    }
}
