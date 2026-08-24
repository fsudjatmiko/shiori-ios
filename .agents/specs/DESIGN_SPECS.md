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

# Active Design Specification: Shiori (Apple-Native Subpage & Standard Chrome)

## 1. Top Navigation Chrome
- Leading: Back chevron.
- Center/Title: Category or Kind title (`.navigationBarTitleDisplayMode(.inline)`).
- Trailing Toolbar: Native `Menu` (`ellipsis.circle`) and Quick Search (`magnifyingglass`).
- No commercial / `PRO` promotional badges.

## 2. Feed List & Native Context Actions
- Container: Standard `List` with `.listStyle(.insetGrouped)`.
- Row Selection: Tap opens native sheet/popover or long-press `.contextMenu` instead of custom inline bars.
- Native Context Menu Actions (per kind):
  - **Link:** Copy Link (`doc.on.doc`), Open in Safari (`safari`), Share (`square.and.arrow.up`).
  - **File:** Quick Look (`eye`), Share (`square.and.arrow.up`), Delete (`trash`, destructive).
  - **Image:** Quick Look (`eye`), Save Image (`square.and.arrow.down`), Share (`square.and.arrow.up`).
  - **Note:** Copy Text (`doc.on.doc`), Edit (`pencil`), Share (`square.and.arrow.up`).

## 3. Persistent Apple-Native Bottom Chrome
- Standard `.toolbar { ToolbarItemGroup(placement: .bottomBar) { ... } }`:
  1. Add Note: `Image(systemName: "square.and.pencil")`
  2. Quick Search: `Image(systemName: "magnifyingglass")` (opens quick command search sheet)
  3. Add Image: `Image(systemName: "photo")`
  4. Add File: `Image(systemName: "doc.badge.plus")`
  5. Settings: `Image(systemName: "gearshape")`
- Distribute icons evenly using native `Spacer()`.