import Foundation
import SharedModels

/// Calculates the next review date for an encounter based on spaced repetition.
/// Uses a simplified Leitner-style schedule aligned with the research report's
/// spacing recommendations: same-day → 1-2 days → 1 week+.
public struct ReviewScheduler: Sendable {
    /// Intervals (in hours) for each review level.
    /// Index = number of completed reviews.
    private let intervals: [TimeInterval]

    public init(intervals: [TimeInterval]? = nil) {
        // Default schedule from the research report timeline:
        // Same-day (4-12h) → 1-2 days (24-48h) → 1 week → 2 weeks → 1 month
        self.intervals = intervals ?? [
            8,      // First review: ~8 hours (same day)
            24,     // Second review: ~1 day
            72,     // Third review: ~3 days
            168,    // Fourth review: ~1 week
            336,    // Fifth review: ~2 weeks
            720,    // Sixth review: ~1 month
        ]
    }

    /// Calculate the next review date for an encounter.
    /// Returns nil if all scheduled reviews are complete.
    public func nextReviewDate(for encounter: Encounter) -> Date? {
        let level = encounter.reviewCount
        guard level < intervals.count else { return nil }

        let hoursUntilNext = intervals[level]
        return encounter.timestamp.addingTimeInterval(hoursUntilNext * 3600)
    }

    /// Mark an encounter as reviewed and schedule the next review.
    public func recordReview(for encounter: Encounter) -> Encounter {
        var updated = encounter
        updated.reviewCount += 1
        updated.nextReviewDate = nextReviewDate(for: updated)
        return updated
    }
}
