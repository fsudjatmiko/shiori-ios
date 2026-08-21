---
trigger: always_on
---

# Active Design Specification: Shiori (Anybox iPhone Flow)

## 1. Visual & Layout Hierarchy
- **Navigation Shell:**
  - Root: `NavigationStack` with Large Title (`.navigationBarTitleDisplayMode(.large)`).
  - Main Container: Single-column `List` with `.listStyle(.insetGrouped)`.
- **Top Section (Smart Folders):**
  - Grouped Section containing primary categories (All Links, Starred, Inbox, Trash).
  - Trailing badge count styling: `.font(.subheadline).foregroundStyle(.secondary)`.
- **Bottom Filter Bar:**
  - Placed via `.toolbar { ToolbarItem(placement: .bottomBar) { ... } }`.
  - Segmented control / picker for content filtering: `All`, `Links`, `Images`, `Notes`.
- **Metrics & Spacing:**
  - Inset Grouped horizontal margin: System default (`16pt`).
  - Row vertical padding: `6pt`.
  - Favicon / Thumbnail size: `28x28pt` with continuous corner radius `6pt`.

## 2. Typography & Color Tokens
- Large Title: `.font(.largeTitle.bold())`
- Section Headers: `.font(.footnote.weight(.semibold)).foregroundStyle(.secondary)`
- Bookmark Item Title: `.font(.body.weight(.medium)).foregroundStyle(.primary)`
- Host URL & Domain Meta: `.font(.caption).foregroundStyle(.secondary)`
- System Colors:
  - Surface: `Color(.systemBackground)`
  - Grouped Container: `Color(.secondarySystemGroupedBackground)`
  - Accent Tint: `Color.accentColor` (System Blue)
  - Starred Highlight: `Color.yellow`

## 3. SF Symbol Mappings
- Folders & Categories:
  - All Links: `Image(systemName: "tray.full.fill")`
  - Starred: `Image(systemName: "star.fill")` (foreground: `.yellow`)
  - Inbox: `Image(systemName: "archivebox.fill")` (foreground: `.blue`)
  - Tags: `Image(systemName: "tag.fill")` (foreground: `.orange`)
  - Trash: `Image(systemName: "trash.fill")` (foreground: `.secondary`)
- Top Bar Actions:
  - Add Item: `Image(systemName: "plus")`
  - View Options / Filter: `Image(systemName: "line.3.horizontal.decrease.circle")`
  - Edit: Standard Apple `EditButton()`

## 4. Micro-Interactions & Haptics
- Category Row Tap: `.sensoryFeedback(.selection, trigger: selectedCategory)`
- Bottom Segment Change: `.sensoryFeedback(.selection, trigger: selectedFilter)`
- Star Toggle: `.sensoryFeedback(.impact(weight: .light), trigger: isStarred)`
- Swipe Delete: `.sensoryFeedback(.impact(weight: .medium), trigger: isDeleted)`

## 5. UI States & Edge Cases
- **Search Drawer:**
  - `.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))`
- **Empty State (Zero Items):**
  - Native `ContentUnavailableView("No Bookmarks", systemImage: "bookmark.slash", description: Text("Saved links and notes will appear here."))`
- **Swipe Actions:**
  - Leading: Toggle Star (`star.fill` / `.yellow`)
  - Trailing: Delete (`trash.fill` / `.destructive`)