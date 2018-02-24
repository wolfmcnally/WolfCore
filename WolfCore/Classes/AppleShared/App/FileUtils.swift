//
//  FileUtils.swift
//  CommonCryptoModule
//
//  Created by Wolf McNally on 2/23/18.
//

public var documentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
