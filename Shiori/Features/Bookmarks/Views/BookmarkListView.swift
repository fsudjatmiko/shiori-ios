import SwiftUI

public struct BookmarkListView: View {
    public let title: String
    @State private var items: [BookmarkItem] = []
    @State private var searchText: String = ""
    @State private var isQuickSearchPresented: Bool = false

    public init(category: SmartCategory, items: [BookmarkItem] = BookmarkItem.sampleData) {
        self.title = category.title
        self._items = State(initialValue: items)
    }

    public init(kind: ContentKind, items: [BookmarkItem] = BookmarkItem.sampleData) {
        self.title = kind.title
        self._items = State(initialValue: items.filter { $0.kind == kind })
    }

    private var filteredItems: [BookmarkItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
            $0.url.localizedCaseInsensitiveContains(searchText)
        }
    }

    public var body: some View {
        Group {
            if filteredItems.isEmpty {
                ContentUnavailableView(
                    "No Bookmarks",
                    systemImage: "bookmark.slash",
                    description: Text("Items saved to this category will appear here.")
                )
            } else {
                List {
                    ForEach(filteredItems) { item in
                        BookmarkItemRowView(item: item, onDelete: { deleteItem(item) })
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
                    Button(action: {}) { Label("Sort by Kind", systemImage: "square.grid.2x2") }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                Button(action: { isQuickSearchPresented = true }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {}) { Label("Note", systemImage: "square.and.pencil") }
                Spacer()
                Button(action: { isQuickSearchPresented = true }) { Label("Search", systemImage: "magnifyingglass") }
                Spacer()
                Button(action: {}) { Label("Image", systemImage: "photo") }
                Spacer()
                Button(action: {}) { Label("File", systemImage: "doc.badge.plus") }
                Spacer()
                Button(action: {}) { Label("Settings", systemImage: "gearshape") }
            }
        }
        .labelStyle(.titleAndIcon)
    }

    private func deleteItem(_ item: BookmarkItem) {
        items.removeAll { $0.id == item.id }
    }
}
