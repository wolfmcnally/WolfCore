//
//  IPAddress4.swift
//  WolfBase
//
//  Created by Wolf McNally on 2/1/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

extension Data {
  public static func ipAddress4(from data: Data) -> String {
    assert(data.count == 4)
    var components = [String]()
    for byte in data {
      components.append(String(byte))
    }
    return components.joined(separator: ".")
  }
}

public class IPAddress4 {
  public static func data(from string: String) throws -> Data {
    let components = string.components(separatedBy: ".")
    guard components.count == 4 else {
      throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
    }
    var data = Data()
    for component in components {
      guard let i = Int(component) else {
        throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
      }
      guard i >= 0 && i <= 255 else {
        throw ValidationError(message: "Invalid IP address.", violation: "ipv4Format")
      }
      data.append([UInt8(i)], count: 1)
    }
    return data
  }
}

extension IPAddress4 {
  public static func test() {
    do {
      let data = Data(bytes: [127, 0, 0, 1])
      let encoded = data |> Data.ipAddress4
      assert(encoded == "127.0.0.1")
      print(encoded)
      let decoded = try encoded |> IPAddress4.data
      assert(decoded == data)
      print(decoded)
    } catch let error {
      logError(error)
    }
  }
}
