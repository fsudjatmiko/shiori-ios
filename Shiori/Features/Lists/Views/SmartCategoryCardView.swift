import SwiftUI

public struct SmartCategoryCardView: View {
    public let category: SmartCategory
    public var count: Int = 0

    public init(category: SmartCategory, count: Int = 0) {
        self.category = category
        self.count = count
    }

    public var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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
