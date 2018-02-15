//
//  MD5.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/19/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if os(Linux)
  import COpenSSL
#else
  import CommonCryptoModule
#endif

public struct MD5 {
  private typealias `Self` = MD5

  #if os(Linux)
  private static let digestLength = Int(MD5_DIGEST_LENGTH)
  #else
  private static let digestLength = Int(CC_MD5_DIGEST_LENGTH)
  #endif

    public private(set) var digest = Data(repeating: 0, count: Self.digestLength)

    public init(data: Data) {
        digest.withUnsafeMutableBytes { (digestPtr: UnsafeMutablePointer<UInt8>) in
            data.withUnsafeBytes { (dataPtr: UnsafePointer<UInt8>) in
                #if os(Linux)
                    _ = COpenSSL.MD5(dataPtr, data.count, digestPtr)
                #else
                    CC_MD5(dataPtr, CC_LONG(data.count), digestPtr)
                #endif
            }
        }
    }

    public static func test() {
        // $ openssl dgst -md5 -hex
        // The quick brown fox\n^d
        // e480132c9dd53e3e34e3cf9f523c7425
        let data = "The quick brown fox\n" |> Data.init
        let md5 = data |> MD5.init
        print(md5)
        // prints e480132c9dd53e3e34e3cf9f523c7425
        let string = md5 |> String.init
        print(string == "e480132c9dd53e3e34e3cf9f523c7425")
        // prints true
    }
}

extension MD5: CustomStringConvertible {
    public var description: String {
        return digest |> Hex.init |> String.init
    }
}

extension String {
    public init(md5: MD5) {
        self.init(md5.description)
    }
}
