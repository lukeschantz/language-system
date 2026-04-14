import Foundation

/// A contextual phrase or etiquette suggestion from the Context Engine.
public struct ContextSuggestion: Identifiable, Sendable {
    public let id: UUID
    /// Time horizon for this suggestion.
    public let horizon: Horizon
    /// The place type this suggestion relates to.
    public let placeType: PlaceType
    /// Suggested phrase in the target language.
    public let phrase: String
    /// Reading/pronunciation for the phrase.
    public let reading: String?
    /// Short English meaning.
    public let meaning: String
    /// Politeness level.
    public let politeness: Politeness
    /// Optional pragmatic/cultural note.
    public let culturalNote: String?

    public init(
        id: UUID = UUID(),
        horizon: Horizon,
        placeType: PlaceType,
        phrase: String,
        reading: String? = nil,
        meaning: String,
        politeness: Politeness = .polite,
        culturalNote: String? = nil
    ) {
        self.id = id
        self.horizon = horizon
        self.placeType = placeType
        self.phrase = phrase
        self.reading = reading
        self.meaning = meaning
        self.politeness = politeness
        self.culturalNote = culturalNote
    }
}

/// When a suggestion is relevant.
public enum Horizon: String, Sendable, Codable {
    /// Right now (0–10 minutes).
    case now
    /// Coming up (1–24 hours).
    case next
}

/// Politeness register for phrase variants.
public enum Politeness: String, Sendable, Codable, CaseIterable {
    case casual
    case polite
    case formal
    case honorific
}
