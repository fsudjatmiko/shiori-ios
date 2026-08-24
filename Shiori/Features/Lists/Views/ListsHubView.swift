import SwiftUI

public struct ListsHubView: View {
    @State private var isKindsExpanded: Bool = true
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(SmartCategory.allCases) { category in
                            NavigationLink(value: category) {
                                SmartCategoryCardView(category: category, count: 0)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        DisclosureGroup(isExpanded: $isKindsExpanded) {
                            VStack(spacing: 0) {
                                ForEach(ContentKind.allCases) { kind in
                                    HStack(spacing: 12) {
                                        Image(systemName: kind.systemImage)
                                            .foregroundStyle(kind.colorTint)
                                            .frame(width: 24)
                                        Text(kind.title)
                                            .font(.body)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.footnote.weight(.semibold))
                                            .foregroundStyle(Color(.tertiaryLabel))
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    if kind != ContentKind.allCases.last {
                                        Divider().padding(.leading, 52)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        } label: {
                            Text("Kinds")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 8)
                .padding(.bottom, 80)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Lists")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SmartCategory.self) { category in
                BookmarkListView(category: category)
            }
            .safeAreaInset(edge: .bottom) {
                ListsBottomBarView()
            }
        }
    }
}

#Preview {
    ListsHubView()
}
