import SwiftUI

public struct BookmarkSubpageBottomDockView: View {
    public var onLightningTap: () -> Void = {}
    public var onIconTap: (String) -> Void = { _ in }

    private let bottomIcons = [
        "note.text",
        "paperplane.fill",
        "photo.on.rectangle.angled",
        "doc.fill",
        "gearshape.fill"
    ]

    public init(
        onLightningTap: @escaping () -> Void = {},
        onIconTap: @escaping (String) -> Void = { _ in }
    ) {
        self.onLightningTap = onLightningTap
        self.onIconTap = onIconTap
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button(action: onLightningTap) {
                    Image(systemName: "bolt.fill")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 3)
                }
                .padding(.trailing, 16)
            }

            HStack {
                ForEach(bottomIcons, id: \.self) { icon in
                    Button {
                        onIconTap(icon)
                    } label: {
                        Image(systemName: icon)
                            .font(.body.weight(.medium))
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
}
