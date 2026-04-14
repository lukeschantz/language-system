import SwiftUI
import SharedModels
import ContextEngine

/// Lets the user select their current place type and see relevant phrases.
/// Implements the "user-confirmed place type + fallback" pattern from the research report.
struct PlaceTypePicker: View {
    @Binding var selection: PlaceType?
    private let contextService = ContextSuggestionService()

    var body: some View {
        List {
            Section("Where are you?") {
                ForEach(commonPlaceTypes, id: \.self) { placeType in
                    Button {
                        selection = placeType
                    } label: {
                        HStack {
                            Label(placeType.displayName, systemImage: placeType.icon)
                                .foregroundStyle(.primary)
                            Spacer()
                            if selection == placeType {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accentColor)
                            }
                        }
                    }
                }
            }

            if let placeType = selection {
                Section("Useful phrases") {
                    let suggestions = contextService.suggestions(placeType: placeType, horizon: .now)
                    if suggestions.isEmpty {
                        Text("No phrases for this location yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(suggestions) { suggestion in
                            SuggestionRow(suggestion: suggestion)
                        }
                    }
                }
            }
        }
    }

    private var commonPlaceTypes: [PlaceType] {
        [.restaurant, .cafe, .station, .shop, .shrine, .temple, .museum, .hotel, .convenienceStore]
    }
}

struct SuggestionRow: View {
    let suggestion: ContextSuggestion

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(suggestion.phrase)
                .font(.headline)
            if let reading = suggestion.reading {
                Text(reading)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(suggestion.meaning)
                .font(.subheadline)
                .foregroundStyle(.blue)
            if let note = suggestion.culturalNote {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - PlaceType display helpers

extension PlaceType {
    var displayName: String {
        switch self {
        case .restaurant: "Restaurant"
        case .cafe: "Cafe"
        case .station: "Train Station"
        case .transit: "Transit"
        case .shop: "Shop"
        case .shrine: "Shrine"
        case .temple: "Temple"
        case .museum: "Museum"
        case .hotel: "Hotel"
        case .street: "Street"
        case .park: "Park"
        case .airport: "Airport"
        case .convenienceStore: "Convenience Store"
        case .other: "Other"
        }
    }

    var icon: String {
        switch self {
        case .restaurant: "fork.knife"
        case .cafe: "cup.and.saucer.fill"
        case .station: "tram.fill"
        case .transit: "bus.fill"
        case .shop: "bag.fill"
        case .shrine: "building.columns.fill"
        case .temple: "building.columns"
        case .museum: "building.2.fill"
        case .hotel: "bed.double.fill"
        case .street: "figure.walk"
        case .park: "leaf.fill"
        case .airport: "airplane"
        case .convenienceStore: "storefront.fill"
        case .other: "mappin.and.ellipse"
        }
    }
}
