import Testing
import Foundation
@testable import SharedModels
@testable import DecodeKit
@testable import MemoryKit

/// Integration tests that verify cross-package workflows.

@Test func fullDecodeAndStorePipeline() async throws {
    // Set up decode service with a test dictionary
    let dict = InMemoryDictionary()
    dict.addEntry(
        LexicalEntry(
            headword: "出口",
            readings: ["でぐち"],
            senses: [Sense(glosses: ["exit"], partsOfSpeech: ["noun"])]
        ),
        for: "出口"
    )

    let decodeService = DecodeService(dictionary: dict)
    let store = InMemoryEncounterStore()

    // Simulate a text region from OCR
    let region = TextRegion(
        text: "出口",
        boundingBox: .init(x: 0.1, y: 0.2, width: 0.3, height: 0.1),
        confidence: 0.92,
        script: .japanese
    )

    // Decode
    let decoded = decodeService.decode(region)

    // Store as encounter
    let encounter = Encounter(
        textRegion: decoded,
        coordinate: Coordinate(latitude: 35.6812, longitude: 139.7671),
        placeType: .station
    )
    try await store.save(encounter)

    // Verify round-trip
    let fetched = try await store.fetch(id: encounter.id)
    #expect(fetched != nil)
    #expect(fetched?.textRegion.text == "出口")
    #expect(fetched?.placeType == .station)
}

@Test func reviewSchedulingEndToEnd() async throws {
    let store = InMemoryEncounterStore()
    let queue = ReviewQueue(store: store)

    let region = TextRegion(text: "ありがとう", boundingBox: .zero, confidence: 0.95)
    let encounter = Encounter(
        textRegion: region,
        timestamp: Date().addingTimeInterval(-10 * 3600) // 10 hours ago
    )

    try await store.save(encounter)
    try await queue.scheduleFirstReview(for: encounter)

    // The first review should be due (8h interval, 10h have passed)
    let due = try await queue.dueForReview()
    #expect(due.count == 1)

    // Mark as reviewed
    try await queue.markReviewed(due[0])

    // Should no longer be immediately due (next interval is 24h)
    let dueAfter = try await queue.dueForReview()
    #expect(dueAfter.isEmpty)
}
