import SwiftUI

public struct ItemActionModalView: View {
    public let item: BookmarkItem
    public var onDismiss: () -> Void = {}
    public var onEdit: () -> Void = {}
    public var onDelete: () -> Void = {}

    public init(item: BookmarkItem, onDismiss: @escaping () -> Void = {}, onEdit: @escaping () -> Void = {}, onDelete: @escaping () -> Void = {}) {
        self.item = item
        self.onDismiss = onDismiss
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text(item.title)
                        .font(.headline.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)

                    if let subtitle = item.contentURL, item.kind == .link {
                        Text(subtitle).font(.footnote).foregroundStyle(.secondary).lineLimit(1)
                    }
                }

                if item.kind == .image, let data = item.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable().scaledToFit()
                        .frame(maxHeight: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else if item.kind == .note, let text = item.noteContent {
                    Text(text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                VStack(spacing: 8) {
                    if let urlStr = item.contentURL, let url = URL(string: urlStr) {
                        Button {
                            UIApplication.shared.open(url)
                            onDismiss()
                        } label: {
                            Text("Open in Safari").font(.body.weight(.semibold)).frame(maxWidth: .infinity).padding(.vertical, 12).background(Color.accentColor).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Button {
                        UIPasteboard.general.string = item.contentURL ?? item.noteContent ?? item.title
                        onDismiss()
                    } label: {
                        Text("Copy").font(.body.weight(.medium)).frame(maxWidth: .infinity).padding(.vertical, 12).background(Color(.secondarySystemFill)).foregroundStyle(.primary).clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        onDismiss()
                        onEdit()
                    } label: {
                        Text("Edit").font(.body.weight(.medium)).frame(maxWidth: .infinity).padding(.vertical, 12).background(Color(.secondarySystemFill)).foregroundStyle(.primary).clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button(role: .destructive) {
                        onDelete()
                        onDismiss()
                    } label: {
                        Text("Delete").font(.body.weight(.medium)).foregroundStyle(.red).padding(.top, 4)
                    }
                }
            }
            .padding(20)
            .frame(width: 320)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
        }
    }
}
