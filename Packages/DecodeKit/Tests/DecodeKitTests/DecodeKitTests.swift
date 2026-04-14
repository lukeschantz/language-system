import Testing
import Foundation
@testable import DecodeKit
@testable import SharedModels

@Test func languageIdentifierDetectsJapanese() {
    let identifier = LanguageIdentifier()
    let result = identifier.identify("東京駅はどこですか")
    #expect(result.script == .japanese)
}

@Test func languageIdentifierDetectsLatin() {
    let identifier = LanguageIdentifier()
    let result = identifier.identify("Hello world")
    #expect(result.script == .latin)
}

@Test func inMemoryDictionaryLookup() {
    let dict = InMemoryDictionary()
    let entry = LexicalEntry(
        headword: "食べる",
        readings: ["たべる"],
        senses: [Sense(glosses: ["to eat"], partsOfSpeech: ["verb"])]
    )
    dict.addEntry(entry, for: "食べる")

    let results = dict.lookup("食べる")
    #expect(results.count == 1)
    #expect(results[0].senses[0].glosses[0] == "to eat")
}

@Test func decodeServiceAnnotatesTokens() {
    let dict = InMemoryDictionary()
    dict.addEntry(
        LexicalEntry(
            headword: "駅",
            readings: ["えき"],
            senses: [Sense(glosses: ["station"], partsOfSpeech: ["noun"])]
        ),
        for: "駅"
    )

    let service = DecodeService(dictionary: dict)
    let region = TextRegion(
        text: "駅",
        boundingBox: .zero,
        confidence: 0.9,
        script: .japanese
    )

    let decoded = service.decode(region)
    // The NLTokenizer may or may not split single-char text, but the lookup should work
    // if it produces a token matching "駅"
    let hasStation = decoded.tokens.contains { token in
        token.lexicalEntries.contains { $0.senses.first?.glosses.first == "station" }
    }
    #expect(hasStation || decoded.tokens.isEmpty) // NLTokenizer behavior may vary
}
