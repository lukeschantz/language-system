import Foundation
import SharedModels

/// Protocol for dictionary lookup backends.
public protocol DictionaryServiceProtocol: Sendable {
    /// Look up a word and return matching lexical entries.
    func lookup(_ query: String) -> [LexicalEntry]
    /// Look up by lemma/dictionary form.
    func lookupLemma(_ lemma: String) -> [LexicalEntry]
}

/// SQLite-backed dictionary service, designed to work with imported JMdict data.
/// The database is a read-only asset bundled with the app or downloaded on first launch.
public final class DictionaryService: DictionaryServiceProtocol, @unchecked Sendable {
    private let databasePath: String
    // Using a simple approach — will use a proper SQLite wrapper (GRDB or raw C API)
    // once the JMdict import pipeline is built.

    public init(databasePath: String) {
        self.databasePath = databasePath
    }

    public func lookup(_ query: String) -> [LexicalEntry] {
        // TODO: Implement SQLite lookup
        // Query plan:
        //   SELECT * FROM entries
        //   JOIN readings ON entries.id = readings.entry_id
        //   JOIN senses ON entries.id = senses.entry_id
        //   JOIN glosses ON senses.id = glosses.sense_id
        //   WHERE entries.headword = ? OR readings.reading = ?
        return []
    }

    public func lookupLemma(_ lemma: String) -> [LexicalEntry] {
        // TODO: Implement SQLite lookup by lemma/dictionary form
        return []
    }
}

/// In-memory dictionary for testing and development.
public final class InMemoryDictionary: DictionaryServiceProtocol, @unchecked Sendable {
    private var entries: [String: [LexicalEntry]]

    public init(entries: [String: [LexicalEntry]] = [:]) {
        self.entries = entries
    }

    public func lookup(_ query: String) -> [LexicalEntry] {
        entries[query] ?? []
    }

    public func lookupLemma(_ lemma: String) -> [LexicalEntry] {
        entries[lemma] ?? []
    }

    /// Add an entry for testing.
    public func addEntry(_ entry: LexicalEntry, for key: String) {
        entries[key, default: []].append(entry)
    }
}
