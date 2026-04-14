import SwiftUI
import SharedModels

/// Root navigation view with tabs for the main app sections.
struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            CaptureTab()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }

            EncountersTab()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            ReviewTab()
                .tabItem {
                    Label("Review", systemImage: "brain.head.profile")
                }

            PhrasesTab()
                .tabItem {
                    Label("Phrases", systemImage: "text.bubble")
                }

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

// MARK: - Tab placeholders

struct CaptureTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)

                Text("Point your camera at text")
                    .font(.title2)

                Text("LanguageLens will decode the structure,\nreading, and meaning of what you see.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Start Camera") {
                    // TODO: Present camera capture view
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .navigationTitle("Scan")
        }
    }
}

struct EncountersTab: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Encounters Yet",
                systemImage: "clock.arrow.circlepath",
                description: Text("Text you scan will appear here with timestamps and locations.")
            )
            .navigationTitle("History")
        }
    }
}

struct ReviewTab: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Nothing to Review",
                systemImage: "brain.head.profile",
                description: Text("Scan some text first. Items will appear here when they're due for review.")
            )
            .navigationTitle("Review")
        }
    }
}

struct PhrasesTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            PlaceTypePicker(selection: $appState.currentPlaceType)
                .navigationTitle("Phrases")
        }
    }
}

struct SettingsTab: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Picker("Scaffold Level", selection: $appState.scaffoldLevel) {
                        Text("Beginner").tag(ScaffoldLevel.beginner)
                        Text("Intermediate").tag(ScaffoldLevel.intermediate)
                        Text("Advanced").tag(ScaffoldLevel.advanced)
                    }
                }

                Section("Location") {
                    Button("Allow Location Access") {
                        appState.locationManager.requestAuthorization()
                    }
                    .disabled(appState.locationManager.isAuthorized)

                    if appState.locationManager.isAuthorized {
                        Label("Location enabled", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }

                Section("About") {
                    LabeledContent("Version", value: "0.1.0")
                    LabeledContent("Dictionary", value: "JMdict (EDRDG)")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
