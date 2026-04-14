import SwiftUI
import SharedModels
import CaptureKit
import DecodeKit
import ContextEngine
import MemoryKit

@main
struct LanguageLensApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

/// Root application state, wiring together all subsystems.
@MainActor
final class AppState: ObservableObject {
    @Published var scaffoldLevel: ScaffoldLevel = .beginner
    @Published var currentPlaceType: PlaceType? = nil

    let captureService: CaptureService
    let decodeService: DecodeService
    let contextService: ContextSuggestionService
    let locationManager: LocationManager
    let encounterStore: InMemoryEncounterStore
    let reviewQueue: ReviewQueue

    init() {
        // Capture
        captureService = CaptureService(recognitionLanguages: ["ja", "en"])

        // Decode — using in-memory dictionary for now
        // Replace with SQLite-backed DictionaryService once JMdict import is built
        let dictionary = InMemoryDictionary()
        decodeService = DecodeService(dictionary: dictionary)

        // Context
        contextService = ContextSuggestionService()
        locationManager = LocationManager()

        // Memory
        let store = InMemoryEncounterStore()
        encounterStore = store
        reviewQueue = ReviewQueue(store: store)
    }
}
