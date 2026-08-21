# Active Design Specification: Shiori (Anybox Replica)

## 1. Visual & Layout Tokens
- **List & Container Styles:**
  - Sidebar: `.listStyle(.sidebar)`
  - Content / Item List: `.listStyle(.insetGrouped)`
- **Metrics & Spacing:**
  - Row Vertical Padding: `8pt`
  - Thumbnail Favicon Size: `24x24pt` with `6pt` corner radius
  - Badge Corner Radius: `4pt` continuous
  - Separator Insets: Standard iOS leading inset aligned with text title
- **Colors & Materials:**
  - Primary Content Surface: `Color(.systemBackground)`
  - Grouped Section Background: `Color(.secondarySystemGroupedBackground)`
  - Accent Color: `Color.accentColor` (System Blue)
  - Destructive Actions: `Color.red`

## 2. Typography Hierarchy (Dynamic Type)
- Navigation Large Title: `.font(.largeTitle.bold())`
- Section Headers: `.font(.footnote.weight(.semibold)).foregroundStyle(.secondary)`
- Bookmark Item Title: `.font(.body.weight(.medium)).foregroundStyle(.primary)`
- Host URL & Domain Meta: `.font(.caption).foregroundStyle(.secondary)`
- Timestamp & Tag Badges: `.font(.caption2.weight(.medium))`

## 3. SF Symbol Mapping & Rendering
- Main Sidebar Sections:
  - All Bookmarks: `Image(systemName: "tray.fill")` (.symbolRenderingMode(.hierarchical))
  - Starred: `Image(systemName: "star.fill")` (foreground: `.yellow`)
  - Tags: `Image(systemName: "tag.fill")` (foreground: `.blue`)
  - Smart Lists: `Image(systemName: "gearshape.2.fill")` (foreground: `.purple`)
  - Trash: `Image(systemName: "trash.fill")` (foreground: `.secondary`)
- Actions & Badges:
  - Copy URL: `Image(systemName: "doc.on.doc")`
  - Open in Browser: `Image(systemName: "safari")`
  - Edit Metadata: `Image(systemName: "slider.horizontal.3")`

## 4. Micro-Interactions & Feedback
- Row Tap / Item Navigation: `.sensoryFeedback(.selection, trigger: selectedBookmark)`
- Star / Favorite Toggle: `.sensoryFeedback(.impact(weight: .light), trigger: isStarred)`
- Swipe Delete / Archive: `.sensoryFeedback(.impact(weight: .medium), trigger: isDeleted)`
- Context Menu Dismiss / Copy: `.sensoryFeedback(.success, trigger: copiedURL)`

## 5. UI States & Edge Cases
- **Empty State (Zero Bookmarks):**
  - Use `ContentUnavailableView("No Bookmarks Found", systemImage: "bookmark.slash", description: Text("Saved URLs and links will appear here."))`
- **Search Filtering:**
  - Native `.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))`
- **Row Swipe Actions:**
  - Trailing: `.destructive` role action with `trash.fill`
  - Leading: `star.fill` favorite toggle
