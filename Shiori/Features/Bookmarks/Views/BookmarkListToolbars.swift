import SwiftUI

struct BookmarkListToolbars: ToolbarContent {
    @Binding var sortOption: SortOption

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Date Modified", systemImage: "clock") { sortOption = .dateModified }
                Button("Name", systemImage: "textformat") { sortOption = .name }
            } label: { Image(systemName: "arrow.up.arrow.down") }
        }
    }
}
