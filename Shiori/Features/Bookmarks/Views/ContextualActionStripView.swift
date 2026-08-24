import SwiftUI

public struct ContextualActionStripView: View {
    public let kind: ContentKind
    public var onAction: (String) -> Void = { _ in }
    @State private var tappedButton: String?

    public init(kind: ContentKind, onAction: @escaping (String) -> Void = { _ in }) {
        self.kind = kind
        self.onAction = onAction
    }

    private var actionIcons: [String] {
        switch kind {
        case .link:
            return ["doc.on.doc", "arrowshape.turn.up.forward", "safari", "info.circle", "square.and.arrow.up"]
        case .file:
            return ["eye", "pencil.tip.crop.circle", "bubble.left.and.bubble.right", "info.circle", "square.and.arrow.up"]
        case .image:
            return ["eye", "photo", "bubble.left.and.bubble.right", "info.circle", "square.and.arrow.up"]
        case .note:
            return ["doc.on.doc", "square.and.pencil", "bubble.left.and.bubble.right", "info.circle", "square.and.arrow.up"]
        }
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(actionIcons, id: \.self) { icon in
                Button {
                    tappedButton = icon
                    onAction(icon)
                } label: {
                    Image(systemName: icon)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .sensoryFeedback(.impact(weight: .light), trigger: tappedButton)
    }
}
