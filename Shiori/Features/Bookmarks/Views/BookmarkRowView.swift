import SwiftUI

public struct BookmarkRowView: View {
    public let item: BookmarkItem
    public var onToggleStar: () -> Void = {}
    public var onDelete: () -> Void = {}

    public init(
        item: BookmarkItem,
        onToggleStar: @escaping () -> Void = {},
        onDelete: @escaping () -> Void = {}
    ) {
        self.item = item
        self.onToggleStar = onToggleStar
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(item.kind.colorTint.opacity(0.15))
                    .frame(width: 28, height: 28)
                Image(systemName: item.kind.systemImage)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(item.kind.colorTint)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(item.host)
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
        .swipeActions(edge: .leading) {
            Button(action: onToggleStar) {
                Label("Star", systemImage: item.isStarred ? "star.slash" : "star.fill")
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash.fill")
            }
            .tint(.red)
        }
    }
}
