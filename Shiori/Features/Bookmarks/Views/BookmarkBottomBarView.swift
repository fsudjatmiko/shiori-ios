import SwiftUI

struct BookmarkBottomBarView: View {
    let onSearchTap: () -> Void
    let onSelectKind: (CreationKind) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSearchTap) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.body.weight(.medium))
                    Text("Search or open...")
                        .font(.body)
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Menu {
                Button { onSelectKind(.note) } label: { Label("New Note", systemImage: "square.and.pencil") }
                Button { onSelectKind(.image) } label: { Label("Add Image", systemImage: "photo") }
                Button { onSelectKind(.file) } label: { Label("Add File", systemImage: "doc.badge.plus") }
                Button { onSelectKind(.link) } label: { Label("Add Link", systemImage: "link") }
            } label: {
                Image(systemName: "plus")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}
