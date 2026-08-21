import SwiftUI

public struct SmartCategoryCardView: View {
    public let category: SmartCategory
    public var count: Int = 0
    public var action: () -> Void = {}
    @State private var isPressed: Bool = false

    public init(category: SmartCategory, count: Int = 0, action: @escaping () -> Void = {}) {
        self.category = category
        self.count = count
        self.action = action
    }

    public var body: some View {
        Button {
            isPressed.toggle()
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: category.systemImage)
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(category.colorTint)
                    Spacer()
                    Text("\(count)")
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                }
                Text(category.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light), trigger: isPressed)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        SmartCategoryCardView(category: .all, count: 42)
        SmartCategoryCardView(category: .starred, count: 12)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
