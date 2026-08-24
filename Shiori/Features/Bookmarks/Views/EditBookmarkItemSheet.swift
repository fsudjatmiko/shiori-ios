import SwiftUI
import SwiftData

public struct EditBookmarkItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: BookmarkItem

    public init(item: BookmarkItem) {
        self.item = item
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $item.title)
                    if item.kind == .link {
                        TextField("URL", text: Binding(
                            get: { item.contentURL ?? "" },
                            set: { item.contentURL = $0.isEmpty ? nil : $0 }
                        ))
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    }
                }

                if item.kind == .note {
                    Section("Note Content") {
                        TextEditor(text: Binding(
                            get: { item.noteContent ?? "" },
                            set: { item.noteContent = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(minHeight: 120)
                    }
                }

                Section("Organization") {
                    Picker("Category", selection: $item.category) {
                        ForEach(SmartCategory.allCases.filter { $0 != .trash }) { category in
                            Label(category.title, systemImage: category.systemImage).tag(category)
                        }
                    }
                    Toggle("Starred", isOn: $item.isStarred)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
