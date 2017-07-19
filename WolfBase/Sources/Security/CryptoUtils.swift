//
//  CryptoUtils.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/21/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if os(Linux)
  import COpenSSL
  typealias KeyRef = UnsafeMutablePointer<RSA>
  typealias Bignum = bignum_st
  typealias BignumRef = UnsafeMutablePointer<Bignum>
  typealias BignumGenCallback = bn_gencb_st
#else
  import Security
#endif

import Foundation

public struct CryptoError: Error {
  public let message: String
  public let code: Int

  public init(message: String, code: Int = 1) {
    self.message = message
    self.code = code
  }

  public var identifier: String {
    return "CryptoError(\(code))"
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

  public static func check(code ret: Int32, message: String) throws {
  if ret != 1 {
  let code = Int(ERR_get_error())
  throw CryptoError(message: message, code: code)
  }
  }
  #else
  public static func check(code: OSStatus, message: String) throws {
    if code != 0 {
      throw CryptoError(message: message, code: Int(code))
    }
  }
  #endif
}

extension CryptoError: CustomStringConvertible {
  public var description: String {
    var c = [message]
    c.append("[\(code)]")

    return "CryptoError(\(c.joined(separator: " ")))"
  }
}

public class CryptoKey: CustomStringConvertible {
  #if os(Linux)
  private let keyRef: KeyRef

  init(keyRef: KeyRef) {
  self.keyRef = keyRef
  }

  deinit {
  RSA_free(keyRef)
  }

  static func bignumToData(_ bn: BignumRef) -> Data {
  let count = Int(BN_bn2mpi(bn, nil))

  var data = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
  defer { data.deallocate(capacity: count) }

  BN_bn2mpi(bn, data)
  let buffer = UnsafeBufferPointer(start: data + 4, count: count - 4)
  return Data(buffer: buffer)
  }

  static func bignumToDecString(_ bn: BignumRef) -> String {
  let sc = BN_bn2dec(bn)!
  defer { OPENSSL_free(sc) }

  return String(cString: sc)
  }

  static func bignumToBase64URL(_ bn: BignumRef) -> Base64URL {
  return bignumToData(bn) |> Base64URL.init
  }

  static func addKeyFieldAsBase64URLToDict(_ dict: inout JSON.Dictionary, field: String, value: BignumRef?) {
  guard let value = value else { return }
  dict[field] = bignumToBase64URL(value).string
  }

  static func addKeyFieldAsBytesToDict(_ dict: inout BSON.Dictionary, field: String, value: BignumRef?) {
  guard let value = value else { return }
  dict[field] = bignumToData(value)
  }

  func json(onlyPublic: Bool, keyID: String? = nil) throws -> JSON.Dictionary {
  var dict = JSON.Dictionary()

  dict["kty"] = "RSA"

  if let keyID = keyID {
  dict["kid"] = String(utf8String: keyID)
  }

  let r = keyRef.pointee
  dict["e"] = Int(BN_get_word(r.e))

  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "n", value: r.n)

  if !onlyPublic {
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "d", value: r.d)
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "p", value: r.p)
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "q", value: r.q)
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "dp", value: r.dmp1)
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "dq", value: r.dmq1)
  type(of: self).addKeyFieldAsBase64URLToDict(&dict, field: "qi", value: r.iqmp)
  }
  return dict
  }

  func bson(onlyPublic: Bool, keyID: String? = nil) throws -> BSON.Dictionary {
  var dict = BSON.Dictionary()

  dict["kty"] = Optional("RSA")
  dict["kid"] = keyID

  let r = keyRef.pointee
  dict["e"] = Optional(Int(BN_get_word(r.e)))

  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "n", value: r.n)

  if !onlyPublic {
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "d", value: r.d)
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "p", value: r.p)
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "q", value: r.q)
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "dp", value: r.dmp1)
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "dq", value: r.dmq1)
  type(of: self).addKeyFieldAsBytesToDict(&dict, field: "qi", value: r.iqmp)
  }
  return dict
  }

  #else

  private let keyRef: SecKey

  init(keyRef: SecKey) {
    self.keyRef = keyRef
  }

  func data() throws -> Data {
    let tag = "tempkey.\(UUID())"
    let tagData = tag |> Data.init

    let query: [NSString: Any] = [
      kSecClass: kSecClassKey,
      kSecAttrKeyType: kSecAttrKeyTypeRSA,
      kSecAttrApplicationTag: tagData as AnyObject
    ]

    var attributes = query
    attributes[kSecValueRef] = keyRef
    attributes[kSecReturnData] = true

    var item: AnyObject?
    try CryptoError.check(code: SecItemAdd(attributes as CFDictionary, &item), message: "Adding temp key to keychain.")
    let keyInfo = item! as! Data
    try CryptoError.check(code: SecItemDelete(query as CFDictionary), message: "Deleting temp key from keychain.")
    return keyInfo
  }

  func json(onlyPublic: Bool, keyID: String? = nil) throws -> JSON.Dictionary {
    var dict = JSON.Dictionary()

    let data = try self.data()

    let fieldNames: [String] = onlyPublic ? ["n", "e"] : ["-version", "n", "e", "d", "p", "q", "dp", "dq", "qi"]
    var nextFieldIndex = 0

    let parser = ASN1Parser(data: data)

    dict["kty"] = "RSA"

    if let kid = keyID {
      dict["kid"] = kid
    }

    parser.foundData = { data in
      let fieldName = fieldNames[nextFieldIndex]
      nextFieldIndex += 1
      if !fieldName.hasPrefix("-") {
        dict[fieldName] = data |> Base64URL.init |> String.init
      }
      //println("BYTES \(fieldName) (\(bytes.count)) \(bytes)")
    }
    parser.didEndDocument = {
      //println("END DOCUMENT")
    }

    try parser.parse()

    return dict
  }

  func bson(onlyPublic: Bool, keyID: String? = nil) throws -> BSON.Dictionary {
    var dict = BSON.Dictionary()

    let data = try self.data()

    let fieldNames: [String] = onlyPublic ? ["n", "e"] : ["-version", "n", "e", "d", "p", "q", "dp", "dq", "qi"]
    var nextFieldIndex = 0

    let parser = ASN1Parser(data: data)

    dict["kty"] = Optional("RSA")
    dict["kid"] = keyID

    parser.foundData = { data in
      let fieldName = fieldNames[nextFieldIndex]
      nextFieldIndex += 1
      if !fieldName.hasPrefix("-") {
        if data.count == 3 && fieldName == "e" {
          let a = Int(data[0]) << 16
          let b = Int(data[1]) << 8
          let c = Int(data[2])
          dict[fieldName] = a | b | c
        } else {
          dict[fieldName] = data
        }
      }
      //println("BYTES \(fieldName) (\(bytes.count)) \(bytes)")
    }
    parser.didEndDocument = {
      //println("END DOCUMENT")
    }

    try parser.parse()

    return dict
  }
  #endif

  public var description: String {
    return "\(keyRef)"
  }
}

public class PublicKey: CryptoKey {
  public override var description: String {
    do {
      return "\(try json(onlyPublic: true))"
    } catch let error {
      logError(error)
      return "invalid"
    }
  }
}

public class PrivateKey: CryptoKey {
  public override var description: String {
    do {
      return "\(try json(onlyPublic: false))"
    } catch let error {
      logError(error)
      return "invalid"
    }
  }
}

public class KeyPair {
  public let publicKey: PublicKey
  public let privateKey: PrivateKey

  public init(publicKey: PublicKey, privateKey: PrivateKey) {
    self.publicKey = publicKey
    self.privateKey = privateKey
  }

  #if os(Linux)
  convenience init(publicKey: KeyRef, privateKey: KeyRef) {
  self.init(publicKey: PublicKey(keyRef: publicKey), privateKey: PrivateKey(keyRef: privateKey))
  }
  #else
  convenience init(publicKey: SecKey, privateKey: SecKey) {
    self.init(publicKey: PublicKey(keyRef: publicKey), privateKey: PrivateKey(keyRef: privateKey))
  }
  #endif
}

public class Crypto {
  #if os(Linux)
  private static var didSetup: Bool = false
  #endif

  public static func setup() throws {
    #if os(Linux)
      guard !didSetup else { return }

      ERR_load_crypto_strings()
      OPENSSL_add_all_algorithms_conf()
      OPENSSL_config(nil)
      let maxBytes = 1024
      let file = "/dev/urandom"
      let bytesRead = Int(RAND_load_file(file, maxBytes))
      if bytesRead != maxBytes {
        throw CryptoError(message: "Seeding RNG.")
      }
      didSetup = true
    #endif
  }

  public static func generateRandomBytes(_ count: Int) -> Data {
    var data = Data(capacity: count)
    #if os(Linux)
      data.withUnsafeMutableBytes { (p: UnsafeMutablePointer<UInt8>) -> Void in
        RAND_bytes(p, Int32(count))
      }
    #else
      data.withUnsafeMutableBytes { (p: UnsafeMutablePointer<UInt8>) -> Void in
        let _ = SecRandomCopyBytes(kSecRandomDefault, count, p)
      }
    #endif
    return data
  }

  public static func testRandom() {
    for _ in 1...3 {
      let bytes = generateRandomBytes(50)
      print(bytes)
    }
  }

  //
  // See "How big an RSA key is considered secure today?"
  // http://crypto.stackexchange.com/questions/1978/how-big-an-rsa-key-is-considered-secure-today
  //
  static let keySize = 2048
  static let exponent = 65537

  public static func generateKeyPair() throws -> KeyPair {
    #if os(Linux)
      var cb = BignumGenCallback()
      cb.ver = 2
      cb.cb.cb_2 = { (a: Int32, b: Int32, arg: UnsafeMutablePointer<BignumGenCallback>?) -> Int32 in
        // print("a: \(a), b: \(b)")
        return 1
      }

      let rsa = try CryptoError.checkNotNil(RSA_new(), message: "Allocating key pair.")
      defer { RSA_free(rsa) }

      let bne = try CryptoError.checkNotNil(BN_new(), message: "Allocating exponent.")
      defer { BN_free(bne) }

      try CryptoError.check(code: BN_set_word(bne, UInt(exponent)), message: "Setting exponent.")
      try withUnsafeMutablePointer(to: &cb) { cbp in
        try CryptoError.check(code: RSA_generate_key_ex(rsa, Int32(keySize), bne, cbp), message: "Generating key pair.")
      }
      let publicKey = RSAPublicKey_dup(rsa)!
      let privateKey = RSAPrivateKey_dup(rsa)!
      return KeyPair(publicKey: publicKey, privateKey: privateKey)
    #else
      var publicKey: SecKey?
      var privateKey: SecKey?
      let parameters: [NSString: Any] = [kSecAttrKeyType: kSecAttrKeyTypeRSA, kSecAttrKeySizeInBits: keySize]
      try CryptoError.check(code: SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey), message: "Generating key pair.")
      return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
    #endif
  }

  public static func testGenerateKeyPair() {
    do {
      try setup()
      let keyPair = try generateKeyPair()

      print("publicKey:")
      let publicBSON = try keyPair.publicKey.bson(onlyPublic: true)
      print(bsonDict: publicBSON)
      let publicBSONBytes = try publicBSON |> BSON.encode
      print("publicBSONBytes: count \(publicBSONBytes.count): \(publicBSONBytes)")

      print("privateKey:")
      let privateBSON = try keyPair.privateKey.bson(onlyPublic: false)
      print(bsonDict: privateBSON)
      let privateBSONBytes = try privateBSON |> BSON.encode
      print("privateBSONBytes: count \(privateBSONBytes.count): \(privateBSONBytes)")
    } catch let error {
      logError(error)
    }
  }
}
