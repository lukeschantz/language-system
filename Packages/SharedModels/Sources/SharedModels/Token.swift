import Foundation

/// A single token (word/morpheme) produced by the decode pipeline.
/// Represents one column in the layered display.
public struct Token: Identifiable, Sendable {
    public let id: UUID
    /// Surface form as it appears in the original text.
    public let surface: String
    /// Reading in the target script's phonetic system (e.g., hiragana for Japanese).
    public let reading: String?
    /// Base/dictionary form (lemma).
    public let lemma: String?
    /// Grammatical role label (e.g., "topic marker", "verb", "particle").
    public let roleLabel: RoleLabel?
    /// Dictionary entries matched for this token.
    public var lexicalEntries: [LexicalEntry]
    /// Character range within the parent TextRegion's text.
    public let range: Range<String.Index>

    public init(
        id: UUID = UUID(),
        surface: String,
        reading: String? = nil,
        lemma: String? = nil,
        roleLabel: RoleLabel? = nil,
        lexicalEntries: [LexicalEntry] = [],
        range: Range<String.Index>
    ) {
        self.id = id
        self.surface = surface
        self.reading = reading
        self.lemma = lemma
        self.roleLabel = roleLabel
        self.lexicalEntries = lexicalEntries
        self.range = range
    }
}

/// Grammatical role labels for the layered display.
/// Kept intentionally simple — these are UX labels, not linguistic categories.
public enum RoleLabel: String, Sendable, Codable, CaseIterable {
    case topicMarker = "topic"
    case subjectMarker = "subject"
    case objectMarker = "object"
    case particle = "particle"
    case verb = "verb"
    case adjective = "adjective"
    case noun = "noun"
    case adverb = "adverb"
    case copula = "copula"
    case counter = "counter"
    case questionParticle = "question"
    case politeEnding = "polite"
    case conjunction = "conjunction"
    case prefix = "prefix"
    case suffix = "suffix"
    case unknown = "unknown"
}
