import SwiftUI
import SwiftData

public struct QuickSearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BookmarkItem.createdAt, order: .reverse) private var allItems: [BookmarkItem]
    @State private var queryText: String = ""
    @FocusState private var isFieldFocused: Bool

    public init() {}

    private var searchResults: [BookmarkItem] {
        let trimmed = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return allItems }
        return allItems.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed) ||
            ($0.contentURL?.localizedCaseInsensitiveContains(trimmed) ?? false) ||
            ($0.noteContent?.localizedCaseInsensitiveContains(trimmed) ?? false)
        }
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("Quick Search bookmarks, notes, files...", text: $queryText)
                        .focused($isFieldFocused)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    if !queryText.isEmpty {
                        Button { queryText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal)
                .padding(.vertical, 8)

                if searchResults.isEmpty {
                    ContentUnavailableView.search(text: queryText)
                } else {
                    List {
                        ForEach(searchResults) { item in
                            BookmarkItemRowView(item: item, onDelete: { modelContext.delete(item) })
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Command Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear { isFieldFocused = true }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
