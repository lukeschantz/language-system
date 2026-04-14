import Testing
import Foundation
@testable import SharedModels

@Test func tokenCreation() {
    let text = "食べる"
    let token = Token(
        surface: text,
        reading: "たべる",
        lemma: "食べる",
        roleLabel: .verb,
        range: text.startIndex..<text.endIndex
    )

    #expect(token.surface == "食べる")
    #expect(token.reading == "たべる")
    #expect(token.roleLabel == .verb)
}

@Test func encounterDefaults() {
    let region = TextRegion(
        text: "出口",
        boundingBox: .zero,
        confidence: 0.95
    )
    let encounter = Encounter(textRegion: region)

    #expect(encounter.reviewCount == 0)
    #expect(encounter.nextReviewDate == nil)
    #expect(encounter.coordinate == nil)
}

@Test func scaffoldLevelDefaults() {
    #expect(ScaffoldLevel.beginner.showsReadingByDefault == true)
    #expect(ScaffoldLevel.beginner.showsMeaningByDefault == true)

    #expect(ScaffoldLevel.intermediate.showsReadingByDefault == false)
    #expect(ScaffoldLevel.intermediate.showsMeaningByDefault == true)

    #expect(ScaffoldLevel.advanced.showsReadingByDefault == false)
    #expect(ScaffoldLevel.advanced.showsMeaningByDefault == false)
}

@Test func contextSuggestionCreation() {
    let suggestion = ContextSuggestion(
        horizon: .now,
        placeType: .restaurant,
        phrase: "すみません",
        reading: "sumimasen",
        meaning: "Excuse me",
        politeness: .polite,
        culturalNote: "Use to get a server's attention — not rude, it's expected."
    )

    #expect(suggestion.horizon == .now)
    #expect(suggestion.politeness == .polite)
    #expect(suggestion.culturalNote != nil)
}
