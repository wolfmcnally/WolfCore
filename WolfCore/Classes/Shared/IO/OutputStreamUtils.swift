//
//  OutputStreamUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

public var standardOutputStream = StandardOutputStream()
public var standardErrorOutputStream = StandardErrorOutputStream()

public class StandardErrorOutputStream: OutputStream {
    public convenience init() {
        self.init(toMemory: ())
    }

    #if os(Linux)
    public required init(toMemory: ()) {
    super.init(toMemory: ())
    }
    #else
    public override init(toMemory: ()) {
        super.init(toMemory: ())
    }
    #endif

    public func write(_ string: String) {
        let stderr = FileHandle.standardError
        stderr.write(string.data(using: String.Encoding.utf8)!)
    }
}

public class StandardOutputStream: OutputStream {
    public convenience init() {
        self.init(toMemory: ())
    }

    #if os(Linux)
    public required init(toMemory: ()) {
    super.init(toMemory: ())
    }
    #else
    public override init(toMemory: ()) {
        super.init(toMemory: ())
    }
    #endif

    public func write(_ string: String) {
        let stdout = FileHandle.standardOutput
        stdout.write(string.data(using: String.Encoding.utf8)!)
    }
}
