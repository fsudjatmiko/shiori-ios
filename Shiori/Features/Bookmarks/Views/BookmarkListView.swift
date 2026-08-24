import SwiftUI

public struct BookmarkListView: View {
    public let category: SmartCategory
    @State private var searchText: String = ""
    @State private var items: [BookmarkItem] = []

    public init(category: SmartCategory, items: [BookmarkItem] = BookmarkItem.sampleData) {
        self.category = category
        self._items = State(initialValue: items)
    }

    private var filteredItems: [BookmarkItem] {
        if searchText.isEmpty {
            return items
        }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
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
                        BookmarkRowView(
                            item: item,
                            onToggleStar: { toggleStar(for: item) },
                            onDelete: { deleteItem(item) }
                        )
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
    }

    private func toggleStar(for item: BookmarkItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isStarred.toggle()
        }
    }

    private func deleteItem(_ item: BookmarkItem) {
        items.removeAll { $0.id == item.id }
    }
}

#Preview {
    NavigationStack {
        BookmarkListView(
            category: .all,
            items: [
                BookmarkItem(title: "Apple Developer Documentation", url: "https://developer.apple.com", kind: .link, isStarred: true),
                BookmarkItem(title: "SwiftUI HIG Design Guidelines", url: "https://developer.apple.com/design", kind: .note)
            ]
        )
    }
}
