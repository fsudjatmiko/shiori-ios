# Apple-Native Engineering & Architecture Rules

## 1. Top-Level Navigation & Chrome (Strict HIG)
- **No Custom App Bars:** Never build fake navbars or manual floating bottom bars using `ZStack` or fixed offsets. Always use standard Apple system chrome:
  - Navigation hierarchy: `NavigationStack` or `NavigationSplitView(sidebar:detail:)` with `.navigationTitle(...)` and `.navigationBarTitleDisplayMode(.large | .inline)`.
  - Floating bottom / tabs: Use native `TabView` and `Tab` with modern styles (e.g., `.tabViewStyle(.sidebarAdaptable)` on iPadOS/macOS).
- **Toolbars:** Use `.toolbar { ToolbarItemGroup(placement:) { ... } }`.
  - Use exact semantic placements: `.topBarLeading`, `.topBarTrailing`, `.bottomBar`, `.primaryAction`, `.cancellationAction`, or `.keyboard`.
  - Let system materials and background effects render natively; avoid custom colored background rectangles behind toolbars.

## 2. Native System Components First
- **Lists & Containers:** Prefer `List` with `.listStyle(.insetGrouped)` or `.listStyle(.sidebar)` for settings, options, and structured items. Use `ScrollView` + `LazyVStack` only for freeform card grids or dashboards.
- **Empty States:** Use native `ContentUnavailableView("Title", systemImage: "icon", description: Text("..."))` instead of custom centered text placeholders.
- **Menus & Context Actions:** Use native `Menu` for dropdowns, `.contextMenu` for long-press menus, and `.swipeActions` for list row shortcuts.
- **Modals & Overlays:** Use `.sheet`, `.fullScreenCover`, and `.presentationDetents([.medium, .large])` rather than custom animated sliding overlay views.

## 3. Visual Tokens & Semantic Styling
- **Colors:** Exclusively use Apple semantic UI colors (`Color(.systemBackground)`, `Color(.secondarySystemBackground)`, `Color.primary`, `Color.secondary`, `Color.accentColor`). Never hardcode custom hex colors unless explicitly specified in `DESIGN_SPECS.md`.
- **Typography:** Exclusively use Apple Dynamic Type text styles (`.font(.largeTitle)`, `.font(.headline)`, `.font(.subheadline)`, `.font(.caption)`). Avoid fixed pixel font sizes (`.font(.system(size: 24))`).
- **Icons:** Use standard SF Symbols (`Image(systemName: "...")`) configured with semantic symbol variants (`.symbolVariant(...)`) and hierarchical rendering (`.symbolRenderingMode(.hierarchical)`).
- **Curves & Borders:** Use continuous corner curvature (`RoundedRectangle(cornerRadius: 12, style: .continuous)`) and standard system strokes (`.strokeBorder(Color(.separator), lineWidth: 0.5)`).

## 4. Modern Architecture & State Boundaries
- **Observation:** Use `@Observable` classes marked with `@MainActor` for all ViewModels. Do not use legacy `ObservableObject` or `@Published`.
- **View Simplicity:** Keep view files under 100 lines. Decompose complex body hierarchies into dedicated child views (`RowView`, `CardView`).
- **Local vs. Business State:** Keep ephemeral UI state (`isPresented`, `isSearching`) inside `@State`. Keep all data mutations, validation, and domain logic inside the ViewModel or Model Context.
- **SwiftData Isolation:** Never run raw database queries directly in child UI views. Pass queries or dependencies cleanly via ViewModels or environment model contexts.

## 5. Micro-Interactions & Haptics
- Attach native sensory feedback:
  - Selection: `.sensoryFeedback(.selection, trigger: selectedItem)`
  - Confirmation/Success: `.sensoryFeedback(.success, trigger: isCompleted)`
  - Delete/Impact: `.sensoryFeedback(.impact(weight: .light), trigger: isDeleted)`
- Use standard spring animation curves: `.spring(response: 0.35, dampingFraction: 0.8)`.

## 6. Code Cleanliness & Commits
- Follow official Swift API Design Guidelines for naming.
- Commit atomically using Conventional Commits: `feat:`, `fix:`, `refactor:`, `ui:`, `chore:`.
