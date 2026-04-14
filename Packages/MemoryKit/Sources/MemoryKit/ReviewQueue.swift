import Foundation
import SharedModels

/// Manages the review queue: surfaces encounters due for review.
public final class ReviewQueue {
    private let store: any EncounterStoreProtocol
    private let scheduler: ReviewScheduler

    public init(
        store: any EncounterStoreProtocol,
        scheduler: ReviewScheduler = ReviewScheduler()
    ) {
        self.store = store
        self.scheduler = scheduler
    }

    /// Get encounters that are due for review now.
    public func dueForReview(asOf now: Date = Date()) async throws -> [Encounter] {
        let all = try await store.fetchAll()
        return all.filter { encounter in
            guard let nextReview = encounter.nextReviewDate else { return false }
            return nextReview <= now
        }
        .sorted { ($0.nextReviewDate ?? .distantFuture) < ($1.nextReviewDate ?? .distantFuture) }
    }

    /// Record that a review happened and update the store.
    public func markReviewed(_ encounter: Encounter) async throws {
        let updated = scheduler.recordReview(for: encounter)
        try await store.update(updated)
    }

    /// Schedule an encounter for its first review (called when encounter is created).
    public func scheduleFirstReview(for encounter: Encounter) async throws {
        var scheduled = encounter
        scheduled.nextReviewDate = scheduler.nextReviewDate(for: encounter)
        try await store.update(scheduled)
    }
}
