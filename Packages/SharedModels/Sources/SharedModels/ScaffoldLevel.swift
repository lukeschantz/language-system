import Foundation

/// The user's current scaffolding level, controlling how much support the overlay shows.
/// Maps directly to the three-level scaffold from the research report.
public enum ScaffoldLevel: Int, Sendable, Codable, CaseIterable {
    /// Character sound + word grouping + short meaning shown by default.
    case beginner = 0
    /// Word grouping + short meaning; character sound on tap.
    case intermediate = 1
    /// Original text only; meaning on tap.
    case advanced = 2

    public var showsReadingByDefault: Bool {
        self == .beginner
    }

    public var showsGroupingByDefault: Bool {
        self != .advanced
    }

    public var showsMeaningByDefault: Bool {
        self != .advanced
    }
}
