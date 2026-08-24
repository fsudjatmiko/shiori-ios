import SwiftUI
import SwiftData

public struct ListsHubView: View {
    @Query private var allItems: [BookmarkItem]
    @State private var isKindsExpanded: Bool = true
    @State private var isAddSheetPresented: Bool = false
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(SmartCategory.allCases) { category in
                            NavigationLink(value: category) {
                                SmartCategoryCardView(category: category, count: count(for: category))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        DisclosureGroup(isExpanded: $isKindsExpanded) {
                            VStack(spacing: 0) {
                                ForEach(ContentKind.allCases) { kind in
                                    NavigationLink(value: kind) { kindRow(for: kind) }.buttonStyle(.plain)
                                    if kind != ContentKind.allCases.last { Divider().padding(.leading, 52) }
                                }
                            }
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        } label: {
                            Text("Kinds").font(.footnote.weight(.semibold)).foregroundStyle(.secondary).textCase(.uppercase)
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
            .navigationDestination(for: SmartCategory.self) { BookmarkListView(category: $0) }
            .navigationDestination(for: ContentKind.self) { BookmarkListView(kind: $0) }
            .safeAreaInset(edge: .bottom) {
                ListsBottomBarView(onNewSmartList: { isAddSheetPresented = true })
            }
            .sheet(isPresented: $isAddSheetPresented) {
                AddBookmarkItemSheet(creationKind: .link)
            }
        }
    }

    @ViewBuilder
    private func kindRow(for kind: ContentKind) -> some View {
        HStack(spacing: 12) {
            Image(systemName: kind.systemImage).foregroundStyle(kind.colorTint).frame(width: 24)
            Text(kind.title).font(.body).foregroundStyle(.primary)
            Spacer()
            Text("\(count(for: kind))").font(.subheadline).foregroundStyle(.secondary)
            Image(systemName: "chevron.right").font(.footnote.weight(.semibold)).foregroundStyle(Color(.tertiaryLabel))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    private func count(for category: SmartCategory) -> Int {
        switch category {
        case .all: allItems.filter { $0.categoryRaw != SmartCategory.trash.rawValue }.count
        case .starred: allItems.filter { $0.isStarred && $0.categoryRaw != SmartCategory.trash.rawValue }.count
        case .untagged: allItems.filter { $0.categoryRaw == SmartCategory.untagged.rawValue }.count
        case .unsorted: allItems.filter { $0.categoryRaw == SmartCategory.unsorted.rawValue }.count
        case .today: allItems.filter { Calendar.current.isDateInToday($0.createdAt) && $0.categoryRaw != SmartCategory.trash.rawValue }.count
        case .trash: allItems.filter { $0.categoryRaw == SmartCategory.trash.rawValue }.count
        }
    }

    private func count(for kind: ContentKind) -> Int {
        allItems.filter { $0.kindRaw == kind.rawValue && $0.categoryRaw != SmartCategory.trash.rawValue }.count
    }
}
