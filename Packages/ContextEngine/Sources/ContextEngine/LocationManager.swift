import CoreLocation
import Combine
import SharedModels

/// Manages location authorization and delivers location updates.
/// Designed to degrade gracefully — the app works without location.
@MainActor
public final class LocationManager: NSObject, ObservableObject {
    @Published public private(set) var currentCoordinate: Coordinate?
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let clManager = CLLocationManager()
    private var delegate: LocationDelegate?

    public override init() {
        super.init()
        let delegate = LocationDelegate { [weak self] coordinate in
            self?.currentCoordinate = coordinate
        } onAuthChange: { [weak self] status in
            self?.authorizationStatus = status
        }
        self.delegate = delegate
        clManager.delegate = delegate
        clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    /// Request when-in-use authorization. No-op if already authorized.
    public func requestAuthorization() {
        guard authorizationStatus == .notDetermined else { return }
        clManager.requestWhenInUseAuthorization()
    }

    /// Start receiving location updates.
    public func startUpdating() {
        guard authorizationStatus == .authorizedWhenInUse ||
              authorizationStatus == .authorizedAlways else { return }
        clManager.startUpdatingLocation()
    }

    /// Stop receiving location updates.
    public func stopUpdating() {
        clManager.stopUpdatingLocation()
    }

    public var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
}

// MARK: - CLLocationManagerDelegate wrapper

private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    let onLocation: (Coordinate) -> Void
    let onAuthChange: (CLAuthorizationStatus) -> Void

    init(
        onLocation: @escaping (Coordinate) -> Void,
        onAuthChange: @escaping (CLAuthorizationStatus) -> Void
    ) {
        self.onLocation = onLocation
        self.onAuthChange = onAuthChange
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onLocation(Coordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onAuthChange(manager.authorizationStatus)
    }
}
