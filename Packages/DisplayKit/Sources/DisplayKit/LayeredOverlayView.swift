import SwiftUI
import SharedModels

/// Displays a decoded TextRegion as a horizontal row of TokenColumnViews.
/// Implements the "character-aligned rows" display from the research report.
///
/// Design rules applied:
/// - Contiguity: annotations directly under their tokens
/// - Segmenting: one region at a time, scrollable
/// - Signaling: selected token gets subtle highlight
public struct LayeredOverlayView: View {
    let region: TextRegion
    let scaffoldLevel: ScaffoldLevel
    @State private var selectedTokenID: UUID?

    public init(region: TextRegion, scaffoldLevel: ScaffoldLevel) {
        self.region = region
        self.scaffoldLevel = scaffoldLevel
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(region.tokens) { token in
                    TokenColumnView(token: token, scaffoldLevel: scaffoldLevel)
                        .background(
                            selectedTokenID == token.id
                                ? Color.accentColor.opacity(0.08)
                                : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedTokenID = selectedTokenID == token.id ? nil : token.id
                            }
                        }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
