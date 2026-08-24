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


# Active Design Specification: Shiori (SwiftData Persistence & Creation Flows)

## 1. SwiftData Schema (`BookmarkItem`)
- `@Model final class BookmarkItem`:
  - `id: UUID` (unique)
  - `title: String`
  - `contentURL: String?`
  - `noteContent: String?`
  - `imageData: Data?`
  - `fileData: Data?`
  - `fileName: String?`
  - `fileSize: Int64?`
  - `categoryRaw: String` (maps to `SmartCategory`)
  - `kindRaw: String` (maps to `ContentKind`)
  - `isStarred: Bool`
  - `createdAt: Date`
  - `updatedAt: Date`

## 2. Dynamic Filtering Predicates
- Top categories filter by `categoryRaw` or `isStarred` / `createdAt` (Today).
- Kinds feed filters strictly by `kindRaw` (link, note, image, file).
- Dynamic count badges on `ListsHubView` reflect `@Query` item counts.

## 3. Creation Modal Flows
- Native sheets with `.presentationDetents([.medium, .large])`.
- Auto-dismiss on save via `@Environment(\.dismiss)`.
- Context insert via `modelContext.insert(item)`.

# Active Design Specification: Shiori (Native Media & Link Pickers)

## 1. Media Picker Capabilities
- **Images:** Integrated `PhotosPicker(selection: $selectedPhotoItem, matching: .images)` from `PhotosUI`. Reads raw `Data` asynchronously and shows an inline `200x120` preview banner before saving.
- **Links:** Dedicated `TextField("https://example.com", text: $urlString)` with `.keyboardType(.URL)`, `.autocapitalization(.none)`, and instant domain extraction preview.
- **Files:** Native `.fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.item])` accessing `URL` securely to extract file name, byte size, and raw payload.

## 2. Validation Rules
- Save button is disabled if required content is missing:
  - Links require a non-empty, valid URL string.
  - Notes require non-empty text.
  - Images require a loaded `Data` payload.
  - Files require a selected file reference.

  # Active Design Specification: Shiori (Item Tap Actions & Editing)

## 1. Tap Interactions
- Tapping a row triggers `.confirmationDialog` or an action sheet for that `BookmarkItem`.
- Action Dialog Buttons:
  - **Open / View:** `safari` / `eye`
  - **Copy Content / Link:** `doc.on.doc`
  - **Edit Item:** `pencil`
  - **Delete:** `trash` (role: `.destructive`)
  - **Cancel:** (role: `.cancel`)

## 2. Edit Flow
- Editing presents `EditBookmarkItemSheet` (.presentationDetents([.medium, .large])).
- Changes mutate the `@Model` directly and save automatically into SwiftData `modelContext`.

# Active Design Specification: Shiori (Centered Action Card & Media Preview)

## 1. Centered Apple Action Modal
- **Layout:** Centered floating card with continuous corner radius `24pt`.
- **Card Background:** `Color(.secondarySystemGroupedBackground)` with subtle elevation shadow.
- **Dimmer:** Dimmed background scrim `Color.black.opacity(0.4)` with tap-to-dismiss.
- **Content Hierarchy:**
  - Item Title: `.font(.headline.weight(.semibold))`.
  - Subtitle / Meta: `.font(.subheadline).foregroundStyle(.secondary)`.
  - **Inline Media Preview:**
    - For Images: Displays the stored image `Data` as a scaled-to-fit rounded preview banner (max height `180pt`).
    - For Notes: Displays a scrollable quote-styled text preview block.
    - For Links: Shows formatted URL host domain badge.
- **Button Group (Stacked Vertical Buttons):**
  - Primary Action (Open / Safari / Fullscreen): Filled blue button style (`.background(Color.accentColor)`).
  - Secondary Action (Copy): Light gray filled button (`.background(Color(.secondarySystemFill))`).
  - Tertiary Action (Edit): Light gray filled button (`.background(Color(.secondarySystemFill))`).
  - Destructive Action (Delete): Red text button or subtle red pill.

  # Active Design Specification: Shiori (Apple-Native Confirmation Dialog)


## 2. Dialog Actions (Per Item)
- Primary Action: "Open in Safari" (for `.link`) / "Quick Look" (for `.image`, `.file`, `.note`).
- Secondary Action: "Copy Link" / "Copy Text" (copies to `UIPasteboard.general.string`).
- Tertiary Action: "Edit" (presents `EditBookmarkItemSheet`).
- Destructive Action: "Delete" with `role: .destructive` (removes from `modelContext`).
- Cancel Action: `role: .cancel` (auto-dismisses).

# Active Design Specification: Shiori (Image Full Preview)

## 1. Image Viewer Component (`ImagePreviewSheet.swift`)
- Native modal sheet / full-screen cover displaying the loaded `UIImage` from `BookmarkItem.imageData`.
- Features pinch-to-zoom / pan or standard `.scaledToFit()`.
- Navigation bar with title, timestamp/size, and a leading/trailing "Done" dismissal button.

## 2. Alert Action
- For `item.kind == .image` (and `item.imageData != nil`), `.alert` presents a "Preview Image" button that sets `@State private var itemToPreview: BookmarkItem?`.

# Active Design Specification: Shiori (Top Sort Menu & Bottom System Bar)

## 1. Top Navigation Bar
- **Trailing Toolbar Action:** Native `Menu` (`arrow.up.arrow.down` or `ellipsis.circle`) for Sorting:
  - Option 1: "Date Modified" (`clock`)
  - Option 2: "Name" (`textformat`)
  - Option 3: "Kind / Type" (`square.grid.2x2`)

# Active Design Specification: Shiori (Apple HIG Floating Search & Ornament)

## 1. Floating Ornament Architecture
- **Left Element (Extended Capsule):** Floating capsule spanning available width with `.ultraThinMaterial`, subtle border stroke (`Color.primary.opacity(0.08)`), containing `magnifyingglass` and "Search or open..." text.
- **Right Element (Circular Action Ornament):** Detached circular button (`Circle()`) with `.ultraThinMaterial`, subtle border stroke, housing a native Apple `Menu` with a standard `plus` icon.
- **Elevation:** Soft ambient shadow (`color: .black.opacity(0.12), radius: 14, y: 5`) floating over list content.

  