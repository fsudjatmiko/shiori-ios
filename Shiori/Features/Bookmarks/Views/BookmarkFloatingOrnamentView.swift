import SwiftUI

struct BookmarkFloatingOrnamentView: View {
    let onSearchTap: () -> Void
    let onSelectKind: (CreationKind) -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSearchTap) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").font(.system(size: 15, weight: .medium)).foregroundStyle(.secondary)
                    Text("Search or open...").font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 16).padding(.vertical, 13)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
            }
            .buttonStyle(.plain)

            Menu {
                Button(action: { onSelectKind(.note) }) { Label("New Note", systemImage: "square.and.pencil") }
                Button(action: { onSelectKind(.image) }) { Label("Add Image", systemImage: "photo") }
                Button(action: { onSelectKind(.file) }) { Label("Add File", systemImage: "doc.badge.plus") }
                Button(action: { onSelectKind(.link) }) { Label("Add Link", systemImage: "link") }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium)).foregroundStyle(.primary)
                    .frame(width: 48, height: 48)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
            }
        }
        .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 5)
        .padding(.horizontal, 16).padding(.bottom, 8)
    }
}
