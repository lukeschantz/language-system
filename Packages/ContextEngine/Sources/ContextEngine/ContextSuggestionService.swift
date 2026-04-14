import Foundation
import SharedModels

/// Provides "Now" and "Next" phrase suggestions based on place type and time.
/// Backed by bundled phrase packs (offline-first).
public final class ContextSuggestionService: Sendable {
    private let phrasePacks: [PlaceType: [ContextSuggestion]]

    public init(phrasePacks: [PlaceType: [ContextSuggestion]] = Self.defaultPacks()) {
        self.phrasePacks = phrasePacks
    }

    /// Get suggestions for the current context.
    public func suggestions(
        placeType: PlaceType,
        horizon: Horizon
    ) -> [ContextSuggestion] {
        let all = phrasePacks[placeType] ?? phrasePacks[.other] ?? []
        return all.filter { $0.horizon == horizon }
    }

    /// Get all suggestions for a place type, both now and next.
    public func allSuggestions(for placeType: PlaceType) -> [ContextSuggestion] {
        phrasePacks[placeType] ?? []
    }

    // MARK: - Default phrase packs (Japanese MVP)

    /// Bundled default phrases for common travel situations.
    /// These will eventually move to a loadable data file.
    public static func defaultPacks() -> [PlaceType: [ContextSuggestion]] {
        [
            .restaurant: [
                ContextSuggestion(
                    horizon: .now, placeType: .restaurant,
                    phrase: "すみません", reading: "sumimasen",
                    meaning: "Excuse me (to get attention)",
                    politeness: .polite,
                    culturalNote: "Standard way to call a server. Not rude — it's expected."
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .restaurant,
                    phrase: "これをください", reading: "kore o kudasai",
                    meaning: "This one, please",
                    politeness: .polite
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .restaurant,
                    phrase: "お会計お願いします", reading: "okaikei onegaishimasu",
                    meaning: "Check, please",
                    politeness: .polite,
                    culturalNote: "Tipping is not customary in Japan."
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .restaurant,
                    phrase: "ごちそうさまでした", reading: "gochisousama deshita",
                    meaning: "Thank you for the meal",
                    politeness: .polite,
                    culturalNote: "Say when leaving. Shows appreciation to the staff."
                ),
            ],
            .station: [
                ContextSuggestion(
                    horizon: .now, placeType: .station,
                    phrase: "〜はどこですか", reading: "~ wa doko desu ka",
                    meaning: "Where is ~?",
                    politeness: .polite
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .station,
                    phrase: "〜行きはどのホームですか", reading: "~iki wa dono hōmu desu ka",
                    meaning: "Which platform for ~?",
                    politeness: .polite
                ),
            ],
            .shrine: [
                ContextSuggestion(
                    horizon: .now, placeType: .shrine,
                    phrase: "写真を撮ってもいいですか", reading: "shashin o tottemo ii desu ka",
                    meaning: "May I take a photo?",
                    politeness: .polite,
                    culturalNote: "Always ask first. Some areas prohibit photography."
                ),
            ],
            .shop: [
                ContextSuggestion(
                    horizon: .now, placeType: .shop,
                    phrase: "いくらですか", reading: "ikura desu ka",
                    meaning: "How much is this?",
                    politeness: .polite
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .shop,
                    phrase: "見ているだけです", reading: "miteiru dake desu",
                    meaning: "I'm just looking",
                    politeness: .polite
                ),
            ],
            .other: [
                ContextSuggestion(
                    horizon: .now, placeType: .other,
                    phrase: "ありがとうございます", reading: "arigatou gozaimasu",
                    meaning: "Thank you (polite)",
                    politeness: .polite
                ),
                ContextSuggestion(
                    horizon: .now, placeType: .other,
                    phrase: "英語を話せますか", reading: "eigo o hanasemasu ka",
                    meaning: "Do you speak English?",
                    politeness: .polite,
                    culturalNote: "Try a few phrases in Japanese first — effort is appreciated."
                ),
            ],
        ]
    }
}
