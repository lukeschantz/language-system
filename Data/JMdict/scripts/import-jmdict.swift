#!/usr/bin/env swift
//
// import-jmdict.swift
//
// Parses JMdict_e.xml and creates a SQLite database for on-device use.
// Run: swift scripts/import-jmdict.swift
//
// Requires: JMdict_e.xml in the Data/JMdict/ directory (run download-jmdict.sh first).
//
// This is a build-time script, not shipped with the app.

import Foundation
import SQLite3

// MARK: - Configuration

let scriptDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let dataDir = scriptDir.deletingLastPathComponent()
let xmlPath = dataDir.appendingPathComponent("JMdict_e.xml").path
let dbPath = dataDir.appendingPathComponent("jmdict.sqlite").path

// MARK: - SQLite helpers

var db: OpaquePointer?

func openDatabase() {
    // Remove existing database
    try? FileManager.default.removeItem(atPath: dbPath)

    guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
        fatalError("Cannot open database: \(String(cString: sqlite3_errmsg(db)))")
    }

    // Performance settings for bulk import
    execute("PRAGMA journal_mode = OFF")
    execute("PRAGMA synchronous = OFF")
    execute("PRAGMA cache_size = 10000")
}

func execute(_ sql: String) {
    guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
        fatalError("SQL error: \(String(cString: sqlite3_errmsg(db))) — \(sql)")
    }
}

func createSchema() {
    execute("""
        CREATE TABLE entries (
            id INTEGER PRIMARY KEY,
            headword TEXT NOT NULL
        )
    """)
    execute("""
        CREATE TABLE readings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entry_id INTEGER NOT NULL REFERENCES entries(id),
            reading TEXT NOT NULL
        )
    """)
    execute("""
        CREATE TABLE senses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entry_id INTEGER NOT NULL REFERENCES entries(id),
            pos TEXT
        )
    """)
    execute("""
        CREATE TABLE glosses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sense_id INTEGER NOT NULL REFERENCES senses(id),
            gloss TEXT NOT NULL,
            lang TEXT DEFAULT 'eng'
        )
    """)
}

func createIndexes() {
    print("Creating indexes...")
    execute("CREATE INDEX idx_entries_headword ON entries(headword)")
    execute("CREATE INDEX idx_readings_reading ON readings(reading)")
    execute("CREATE INDEX idx_readings_entry ON readings(entry_id)")
    execute("CREATE INDEX idx_senses_entry ON senses(entry_id)")
    execute("CREATE INDEX idx_glosses_sense ON glosses(sense_id)")
}

// MARK: - XML Parsing (stub)

// Full XML parsing implementation will use Foundation's XMLParser to walk
// the JMdict structure:
//   <entry> → <ent_seq>, <k_ele>/<keb>, <r_ele>/<reb>, <sense>/<gloss>
//
// For now, this prints a placeholder message.

func importEntries() {
    guard FileManager.default.fileExists(atPath: xmlPath) else {
        print("ERROR: JMdict_e.xml not found at \(xmlPath)")
        print("Run download-jmdict.sh first.")
        return
    }

    print("Parsing \(xmlPath)...")
    print("TODO: Implement full XMLParser-based import.")
    print("Schema created at \(dbPath)")
}

// MARK: - Main

print("JMdict → SQLite importer")
print("========================")
openDatabase()
createSchema()
execute("BEGIN TRANSACTION")
importEntries()
execute("COMMIT")
createIndexes()
sqlite3_close(db)
print("Done.")
