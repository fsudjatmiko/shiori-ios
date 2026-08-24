import SwiftUI
import SwiftData

public struct BookmarkListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [BookmarkItem]
    public let title: String
    @State private var searchText: String = ""
    @State private var isQuickSearchPresented: Bool = false
    @State private var activeSheet: CreationKind? = nil

    public init(category: SmartCategory) {
        self.title = category.title
        let categoryRaw = category.rawValue
        let trashRaw = SmartCategory.trash.rawValue
        let startOfToday = Calendar.current.startOfDay(for: Date())
        _items = Query(filter: #Predicate<BookmarkItem> { item in
            if categoryRaw == "all" { return item.categoryRaw != trashRaw }
            else if categoryRaw == "starred" { return item.isStarred && item.categoryRaw != trashRaw }
            else if categoryRaw == "today" { return item.createdAt >= startOfToday && item.categoryRaw != trashRaw }
            else { return item.categoryRaw == categoryRaw }
        }, sort: \.createdAt, order: .reverse)
    }

    public init(kind: ContentKind) {
        self.title = kind.title
        let kindRaw = kind.rawValue
        let trashRaw = SmartCategory.trash.rawValue
        _items = Query(filter: #Predicate<BookmarkItem> { $0.kindRaw == kindRaw && $0.categoryRaw != trashRaw }, sort: \.createdAt, order: .reverse)
    }

    private var filteredItems: [BookmarkItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.formattedSubtitle.localizedCaseInsensitiveContains(searchText) ||
            ($0.contentURL?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    public var body: some View {
        Group {
            if filteredItems.isEmpty {
                ContentUnavailableView("No Bookmarks", systemImage: "bookmark.slash", description: Text("Items saved to this category will appear here."))
            } else {
                List {
                    ForEach(filteredItems) { item in
                        BookmarkItemRowView(item: item, onDelete: { modelContext.delete(item) })
                            .swipeActions(edge: .leading) {
                                Button { item.isStarred.toggle() } label: {
                                    Label(item.isStarred ? "Unstar" : "Star", systemImage: item.isStarred ? "star.slash" : "star.fill")
                                }.tint(.yellow)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) { modelContext.delete(item) } label: { Label("Delete", systemImage: "trash.fill") }
                            }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button(action: {}) { Label("Sort by Date", systemImage: "calendar") }
                    Button(action: {}) { Label("Sort by Name", systemImage: "textformat") }
                } label: { Image(systemName: "ellipsis.circle") }
                Button(action: { activeSheet = .link }) { Image(systemName: "plus") }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: { isQuickSearchPresented = true }) { Image(systemName: "magnifyingglass") }
                Spacer()
                Button(action: { activeSheet = .note }) { Image(systemName: "square.and.pencil") }
                Spacer()
                Button(action: { activeSheet = .image }) { Image(systemName: "photo") }
                Spacer()
                Button(action: { activeSheet = .file }) { Image(systemName: "doc.badge.plus") }
                Spacer()
                Button(action: { activeSheet = .link }) { Image(systemName: "link") }
            }
        }
        .sheet(item: $activeSheet) { AddBookmarkItemSheet(creationKind: $0) }
    }
}
