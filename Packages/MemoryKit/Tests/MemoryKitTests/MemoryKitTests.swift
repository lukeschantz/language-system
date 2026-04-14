import Testing
import Foundation
@testable import MemoryKit
@testable import SharedModels

@Test func reviewSchedulerFirstInterval() {
    let scheduler = ReviewScheduler()
    let region = TextRegion(text: "出口", boundingBox: .zero, confidence: 0.9)
    let encounter = Encounter(textRegion: region, timestamp: Date())

    let nextDate = scheduler.nextReviewDate(for: encounter)
    #expect(nextDate != nil)

    // First review should be ~8 hours after encounter
    let hours = nextDate!.timeIntervalSince(encounter.timestamp) / 3600
    #expect(hours >= 7 && hours <= 9)
}

@Test func reviewSchedulerProgresses() {
    let scheduler = ReviewScheduler()
    let region = TextRegion(text: "駅", boundingBox: .zero, confidence: 0.9)
    var encounter = Encounter(textRegion: region, timestamp: Date())

    // Simulate 6 reviews — should eventually return nil
    for _ in 0..<6 {
        encounter = scheduler.recordReview(for: encounter)
    }
    #expect(encounter.reviewCount == 6)
    #expect(encounter.nextReviewDate == nil) // All scheduled reviews complete
}

@Test func encounterStoreSaveAndFetch() async throws {
    let store = InMemoryEncounterStore()
    let region = TextRegion(text: "食べる", boundingBox: .zero, confidence: 0.95)
    let encounter = Encounter(textRegion: region)

    try await store.save(encounter)
    let fetched = try await store.fetch(id: encounter.id)
    #expect(fetched?.textRegion.text == "食べる")
}

@Test func reviewQueueReturnsDueItems() async throws {
    let store = InMemoryEncounterStore()
    let queue = ReviewQueue(store: store)

    let region = TextRegion(text: "出口", boundingBox: .zero, confidence: 0.9)
    var encounter = Encounter(
        textRegion: region,
        timestamp: Date().addingTimeInterval(-10 * 3600) // 10 hours ago
    )
    encounter.nextReviewDate = Date().addingTimeInterval(-3600) // Due 1 hour ago
    try await store.save(encounter)

    let due = try await queue.dueForReview()
    #expect(due.count == 1)
}
