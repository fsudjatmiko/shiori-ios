import SwiftUI
import SwiftData

public enum SortOption { case dateModified, name }

public struct BookmarkListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [BookmarkItem]
    public let title: String
    @State private var sortOption: SortOption = .dateModified
    @State private var showQuickSearch: Bool = false
    @State private var activeSheet: CreationKind? = nil
    @State private var selectedItemForDialog: BookmarkItem? = nil
    @State private var itemToEdit: BookmarkItem? = nil
    @State private var itemToPreview: BookmarkItem? = nil

    public init(category: SmartCategory) {
        self.title = category.title
        let cat = category.rawValue, trash = SmartCategory.trash.rawValue, today = Calendar.current.startOfDay(for: Date())
        _items = Query(filter: #Predicate<BookmarkItem> { item in
            if cat == "all" { return item.categoryRaw != trash }
            else if cat == "starred" { return item.isStarred && item.categoryRaw != trash }
            else if cat == "today" { return item.createdAt >= today && item.categoryRaw != trash }
            else { return item.categoryRaw == cat }
        }, sort: \.createdAt, order: .reverse)
    }

    public init(kind: ContentKind) {
        self.title = kind.title
        let k = kind.rawValue, trash = SmartCategory.trash.rawValue
        _items = Query(filter: #Predicate<BookmarkItem> { $0.kindRaw == k && $0.categoryRaw != trash }, sort: \.createdAt, order: .reverse)
    }

    private var sortedItems: [BookmarkItem] {
        let base = items.filter { $0.categoryRaw != SmartCategory.trash.rawValue }
        return sortOption == .dateModified ? base.sorted { $0.updatedAt > $1.updatedAt } : base.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    public var body: some View {
        Group {
            if sortedItems.isEmpty {
                ContentUnavailableView("No Bookmarks", systemImage: "bookmark.slash", description: Text("Items saved to this category will appear here."))
            } else {
                List {
                    ForEach(sortedItems) { item in
                        BookmarkItemRowView(item: item, onDelete: { modelContext.delete(item) })
                            .contentShape(Rectangle()).onTapGesture { selectedItemForDialog = item }
                            .swipeActions(edge: .leading) { Button { item.isStarred.toggle() } label: { Label(item.isStarred ? "Unstar" : "Star", systemImage: item.isStarred ? "star.slash" : "star.fill") }.tint(.yellow) }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) { Button(role: .destructive) { modelContext.delete(item) } label: { Label("Delete", systemImage: "trash.fill") } }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
        .toolbar { BookmarkListToolbars(sortOption: $sortOption) }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 60) }
        .overlay(alignment: .bottom) {
            BookmarkFloatingOrnamentView(onSearchTap: { showQuickSearch = true }, onSelectKind: { activeSheet = $0 })
        }
        .sheet(item: $activeSheet) { AddBookmarkItemSheet(creationKind: $0) }
        .sheet(isPresented: $showQuickSearch) { QuickSearchSheet() }
        .sheet(item: $itemToEdit) { EditBookmarkItemSheet(item: $0) }
        .sheet(item: $itemToPreview) { ImagePreviewSheet(item: $0) }
        .alert(selectedItemForDialog?.title ?? "Item Options", isPresented: Binding(get: { selectedItemForDialog != nil }, set: { if !$0 { selectedItemForDialog = nil } }), presenting: selectedItemForDialog) { item in
            if item.kind == .image && item.imageData != nil { Button("Preview Image") { itemToPreview = item } }
            else if item.kind == .link, let url = item.contentURL.flatMap(URL.init) { Button("Open in Safari") { UIApplication.shared.open(url) } }
            Button(item.kind == .link ? "Copy Link" : "Copy Content") { UIPasteboard.general.string = item.contentURL ?? item.noteContent ?? item.title }
            Button("Edit") { itemToEdit = item }
            Button("Delete", role: .destructive) { modelContext.delete(item) }
            Button("Cancel", role: .cancel) {}
        } message: { Text($0.formattedSubtitle) }
    }
}
