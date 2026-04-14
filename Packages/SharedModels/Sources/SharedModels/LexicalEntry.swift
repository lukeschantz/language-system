import Foundation

/// A dictionary entry for a word or phrase.
/// Modeled after JMdict structure but kept generic for other dictionaries.
public struct LexicalEntry: Identifiable, Sendable {
    public let id: UUID
    /// Dictionary form / headword.
    public let headword: String
    /// Reading(s) for the headword.
    public let readings: [String]
    /// Sense groups, each containing one or more meanings.
    public let senses: [Sense]

    public init(
        id: UUID = UUID(),
        headword: String,
        readings: [String] = [],
        senses: [Sense] = []
    ) {
        self.id = id
        self.headword = headword
        self.readings = readings
        self.senses = senses
    }
}

/// A single sense (meaning group) within a dictionary entry.
public struct Sense: Sendable {
    /// Short gloss in user's L1 (e.g., English).
    public let glosses: [String]
    /// Part of speech tags.
    public let partsOfSpeech: [String]
    /// Usage notes or field markers (e.g., "formal", "colloquial", "food").
    public let tags: [String]

    public init(
        glosses: [String] = [],
        partsOfSpeech: [String] = [],
        tags: [String] = []
    ) {
        self.glosses = glosses
        self.partsOfSpeech = partsOfSpeech
        self.tags = tags
    }
}
