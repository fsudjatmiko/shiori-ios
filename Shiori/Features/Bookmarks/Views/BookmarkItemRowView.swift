import SwiftUI

public struct BookmarkItemRowView: View {
    public let item: BookmarkItem
    public var onDelete: () -> Void = {}

    public init(item: BookmarkItem, onDelete: @escaping () -> Void = {}) {
        self.item = item
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(item.kind.colorTint.opacity(0.15))
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: item.previewImageName ?? item.iconName)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(item.kind.colorTint)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if item.isStarred {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 4)
        .contextMenu { contextMenuActions }
    }

    @ViewBuilder
    private var contextMenuActions: some View {
        switch item.kind {
        case .link:
            Button(action: {}) { Label("Copy Link", systemImage: "doc.on.doc") }
            Button(action: {}) { Label("Open in Safari", systemImage: "safari") }
            Button(action: {}) { Label("Share", systemImage: "square.and.arrow.up") }
        case .file:
            Button(action: {}) { Label("Quick Look", systemImage: "eye") }
            Button(action: {}) { Label("Share", systemImage: "square.and.arrow.up") }
        case .image:
            Button(action: {}) { Label("Quick Look", systemImage: "eye") }
            Button(action: {}) { Label("Save Image", systemImage: "square.and.arrow.down") }
            Button(action: {}) { Label("Share", systemImage: "square.and.arrow.up") }
        case .note:
            Button(action: {}) { Label("Copy Text", systemImage: "doc.on.doc") }
            Button(action: {}) { Label("Edit", systemImage: "pencil") }
            Button(action: {}) { Label("Share", systemImage: "square.and.arrow.up") }
        }
        Button(role: .destructive, action: onDelete) {
            Label("Delete", systemImage: "trash")
        }
    }
}
