import SwiftUI
import SharedModels

/// A detail sheet for a selected token or text region.
/// Shows full dictionary entries, cultural notes, and deeper explanation.
/// Preserves structural alignment (not long paragraphs) per research report rules.
public struct InspectSheetView: View {
    let token: Token
    @Environment(\.dismiss) private var dismiss

    public init(token: Token) {
        self.token = token
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header: surface + reading
                    headerSection

                    if let role = token.roleLabel {
                        roleLabelSection(role)
                    }

                    // Dictionary entries
                    ForEach(token.lexicalEntries) { entry in
                        dictionaryEntrySection(entry)
                    }

                    if token.lexicalEntries.isEmpty {
                        Text("No dictionary entries found.")
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                }
                .padding()
            }
            .navigationTitle("Inspect")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(token.surface)
                .font(.largeTitle)
            if let reading = token.reading {
                Text(reading)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            if let lemma = token.lemma, lemma != token.surface {
                Text("Dictionary form: \(lemma)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func roleLabelSection(_ role: RoleLabel) -> some View {
        HStack {
            Text(role.rawValue.capitalized)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.orange.opacity(0.1), in: Capsule())
        }
    }

    private func dictionaryEntrySection(_ entry: LexicalEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text(entry.headword)
                .font(.headline)

            if !entry.readings.isEmpty {
                Text(entry.readings.joined(separator: "、"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(Array(entry.senses.enumerated()), id: \.offset) { index, sense in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 20, alignment: .trailing)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(sense.glosses.joined(separator: "; "))
                            .font(.body)

                        if !sense.partsOfSpeech.isEmpty {
                            Text(sense.partsOfSpeech.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if !sense.tags.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(sense.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.gray.opacity(0.15), in: Capsule())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
