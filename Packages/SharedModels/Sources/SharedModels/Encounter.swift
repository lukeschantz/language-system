import Foundation
import CoreLocation

/// A recorded encounter with text in the real world.
/// The core unit of the Memory subsystem.
public struct Encounter: Identifiable, Sendable {
    public let id: UUID
    /// Snapshot of the recognized text region.
    public let textRegion: TextRegion
    /// When the encounter occurred.
    public let timestamp: Date
    /// Where the encounter occurred (nil if location not authorized).
    public let coordinate: Coordinate?
    /// User-confirmed or inferred place type.
    public let placeType: PlaceType?
    /// Path to the saved image snapshot on disk (relative to app documents).
    public let imagePath: String?
    /// Number of times this encounter has been reviewed.
    public var reviewCount: Int
    /// When the next review is scheduled (nil if not in review queue).
    public var nextReviewDate: Date?

    public init(
        id: UUID = UUID(),
        textRegion: TextRegion,
        timestamp: Date = Date(),
        coordinate: Coordinate? = nil,
        placeType: PlaceType? = nil,
        imagePath: String? = nil,
        reviewCount: Int = 0,
        nextReviewDate: Date? = nil
    ) {
        self.id = id
        self.textRegion = textRegion
        self.timestamp = timestamp
        self.coordinate = coordinate
        self.placeType = placeType
        self.imagePath = imagePath
        self.reviewCount = reviewCount
        self.nextReviewDate = nextReviewDate
    }
}

/// Sendable wrapper for location data (CLLocationCoordinate2D is not Sendable).
public struct Coordinate: Sendable, Codable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// High-level place type for context engine inference.
public enum PlaceType: String, Sendable, Codable, CaseIterable {
    case restaurant
    case cafe
    case station
    case transit
    case shop
    case shrine
    case temple
    case museum
    case hotel
    case street
    case park
    case airport
    case convenienceStore = "convenience_store"
    case other
}
