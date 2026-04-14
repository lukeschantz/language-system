import SwiftUI
import SharedModels

/// Displays a single token as a vertical column of aligned rows:
/// Original → Reading → Meaning
///
/// This is the atomic unit of the layered display. Each row is spatially
/// contiguous with the token it annotates (contiguity rule from research).
public struct TokenColumnView: View {
    let token: Token
    let scaffoldLevel: ScaffoldLevel
    @State private var isExpanded = false

    public init(token: Token, scaffoldLevel: ScaffoldLevel) {
        self.token = token
        self.scaffoldLevel = scaffoldLevel
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 2) {
            // Row 1: Original text (always shown)
            Text(token.surface)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.primary)

            // Row 2: Reading (e.g., hiragana)
            if let reading = token.reading,
               (scaffoldLevel.showsReadingByDefault || isExpanded) {
                Text(reading)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            // Row 3: Short meaning
            if let meaning = shortMeaning,
               (scaffoldLevel.showsMeaningByDefault || isExpanded) {
                Text(meaning)
                    .font(.system(size: 11))
                    .foregroundStyle(.blue)
                    .lineLimit(1)
            }

            // Row 4: Role label (optional, on tap)
            if let role = token.roleLabel, isExpanded {
                Text(role.rawValue)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 3))
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        }
    }

    /// First gloss from the first sense of the first lexical entry.
    private var shortMeaning: String? {
        token.lexicalEntries
            .first?.senses
            .first?.glosses
            .first
    }
}
