//
//  SQLite.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/6/15.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import SQLite3

//
// Useful: http://stackoverflow.com/questions/24102775/accessing-an-sqlite-database-in-swift
//

public enum SQLiteReturnCode: Int32 {
    case ok = 0         /* Successful result */

    case error          /* SQL error or missing database */
    case internErr      /* Internal logic error in SQLite */
    case perm           /* Access permission denied */
    case abort          /* Callback routine requested an abort */
    case busy           /* The database file is locked */
    case locked         /* A table in the database is locked */
    case noMem          /* A malloc() failed */
    case readOnly       /* Attempt to write a readonly database */
    case interrupt      /* Operation terminated by sqlite3_interrupt()*/
    case ioErr          /* Some kind of disk I/O error occurred */
    case corrupt        /* The database disk image is malformed */
    case notFound       /* Unknown opcode in sqlite3_file_control() */
    case full           /* Insertion failed because database is full */
    case cantOpen       /* Unable to open the database file */
    case protocolErr    /* Database lock protocol error */
    case empty          /* Database is empty */
    case schema         /* The database schema changed */
    case tooBig         /* String or BLOB exceeds size limit */
    case constraint     /* Abort due to constraint violation */
    case mismatch       /* Data type mismatch */
    case misuse         /* Library used incorrectly */
    case noLFS          /* Uses OS features not supported on host */
    case auth           /* Authorization denied */
    case format         /* Auxiliary database format error */
    case range          /* 2nd parameter to sqlite3_bind out of range */
    case notADB         /* File opened that is not a database file */
    case notice         /* Notifications from sqlite3_log() */
    case warning        /* Warnings from sqlite3_log() */
}

public enum SQLiteStepResult: Int32 {
    case row = 100  /* sqlite3_step() has another row ready */
    case done       /* sqlite3_step() has finished executing */
}

let sqliteStatic = unsafeBitCast(0, to: sqlite3_destructor_type.self)
let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

extension SQLiteReturnCode: DescriptiveError {
    public var message: String {
        return "\(rawValue)"
    }

    public var code: Int {
        return Int(rawValue)
    }

    public var identifier: String {
        return "SQLiteReturnCode(\(code))"
    }

    public var isCancelled: Bool { return false }
}

extension SQLiteReturnCode: CustomStringConvertible {
    public var description: String {
        return "\(message)"
    }
}

public class SQLite {
    private var db: OpaquePointer?

    public init(fileURL: URL) throws {
        let error = SQLiteReturnCode(rawValue: sqlite3_open(fileURL.path, &db))!
        guard error == .ok else {
            throw error
        }
    }

    deinit {
        sqlite3_close(db)
    }

    public func exec(sql: String) throws {
        let error = SQLiteReturnCode(rawValue: sqlite3_exec(db, sql, nil, nil, nil))!
        guard error == .ok else {
            throw error
        }
    }

    public func prepare(sql: String) throws -> Statement {
        return try Statement(db: self, sql: sql)
    }

    public func beginTransaction() {
        try! exec(sql: "BEGIN")
    }

    public func commitTransaction() {
        try! exec(sql: "COMMIT")
    }

    public func rollbackTransaction() {
        try! exec(sql: "ROLLBACK")
    }

    public class Statement {
        let db: SQLite
        let sql: String
        var statement: OpaquePointer?

        init(db: SQLite, sql: String) throws {
            self.db = db
            self.sql = sql
            let error = SQLiteReturnCode(rawValue: sqlite3_prepare_v2(db.db, sql, -1, &statement, nil))!
            guard error == .ok else {
                throw error
            }
        }

        deinit {
            sqlite3_finalize(statement)
        }

        private func indexForParameter(named name: String) -> Int {
            return Int(sqlite3_bind_parameter_index(statement, ":\(name)"))
        }

        public func bindParameter(atIndex index: Int, toInt n: Int) {
            sqlite3_bind_int(statement, Int32(index), Int32(n))
        }

        public func bindParameter(atIndex index: Int, toURL url: URL) {
            sqlite3_bind_text(statement, Int32(index), url.absoluteString, -1, sqliteTransient)
        }

        public func bindParameter(atIndex index: Int, toBLOB data: Data) {
            _ = data.withUnsafeBytes { p in
                sqlite3_bind_blob(statement, Int32(index), p, Int32(data.count), sqliteTransient)
            }
        }

        public func bindParameter(named name: String, toInt n: Int) {
            bindParameter(atIndex: indexForParameter(named: name), toInt: n)
        }

        public func bindParameter(named name: String, toURL url: URL) {
            bindParameter(atIndex: indexForParameter(named: name), toURL: url)
        }

        public func bindParameter(named name: String, toBLOB data: Data) {
            bindParameter(atIndex: indexForParameter(named: name), toBLOB: data)
        }

        @discardableResult public func step() throws -> SQLiteStepResult {
            let rawReturnCode = sqlite3_step(statement)
            if let stepResult = SQLiteStepResult(rawValue: rawReturnCode) {
                return stepResult
            } else {
                throw SQLiteReturnCode(rawValue: rawReturnCode)!
            }
        }

        public func reset() {
            sqlite3_reset(statement)
        }

        public var columnCount: Int {
            return Int(sqlite3_column_count(statement))
        }

        public func columnName(forIndex index: Int) -> String {
            let s = sqlite3_column_name(statement, Int32(index))!
            return String(validatingUTF8: s)!
        }

        public func intValue(forColumnIndex index: Int) -> Int {
            return Int(sqlite3_column_int(statement, Int32(index)))
        }

        public func stringValue(forColumnIndex index: Int) -> String? {
            if let s = sqlite3_column_text(statement, Int32(index)) {
                return String(cString: s)
            } else {
                return nil
            }
        }

        public func urlValue(forColumnIndex index: Int) -> URL? {
            if let string = stringValue(forColumnIndex: index) {
                return URL(string: string)
            } else {
                return nil
            }
        }

        public func blobValue(forColumnIndex index: Int) -> Data? {
            if let b = sqlite3_column_blob(statement, Int32(index)) {
                let count = Int(sqlite3_column_bytes(statement, Int32(index)))
                return Data(bytes: b, count: count)
            } else {
                return nil
            }
        }
    }
}
