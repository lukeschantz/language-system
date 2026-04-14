import SharedModels

/// Infers the user's current place type from available signals.
/// Intentionally simple for MVP — user override is always available.
public struct PlaceTypeClassifier: Sendable {
    public init() {}

    /// Classify based on a user-provided override. This is the primary path for MVP.
    public func classify(userOverride: PlaceType?) -> PlaceType {
        if let override = userOverride {
            return override
        }
        // TODO: In future iterations, use reverse geocoding + MapKit POI data
        // to infer place type from coordinates. The research report warns that
        // misclassification harms trust, so user confirmation is always preferred.
        return .other
    }
}
