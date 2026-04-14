import Testing
@testable import ContextEngine
@testable import SharedModels

@Test func defaultPacksContainRestaurantPhrases() {
    let service = ContextSuggestionService()
    let suggestions = service.suggestions(placeType: .restaurant, horizon: .now)
    #expect(!suggestions.isEmpty)
    #expect(suggestions.allSatisfy { $0.placeType == .restaurant })
}

@Test func unknownPlaceFallsBackToOther() {
    let service = ContextSuggestionService()
    let suggestions = service.allSuggestions(for: .museum)
    // Museum has no specific pack, should return empty (not crash)
    #expect(suggestions.isEmpty)
}

@Test func placeTypeClassifierRespectsOverride() {
    let classifier = PlaceTypeClassifier()
    let result = classifier.classify(userOverride: .shrine)
    #expect(result == .shrine)
}

@Test func placeTypeClassifierDefaultsToOther() {
    let classifier = PlaceTypeClassifier()
    let result = classifier.classify(userOverride: nil)
    #expect(result == .other)
}
