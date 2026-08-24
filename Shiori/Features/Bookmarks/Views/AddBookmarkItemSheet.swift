import SwiftUI
import SwiftData
import PhotosUI

public enum CreationKind: String, Identifiable, CaseIterable {
    case link = "Link", note = "Note", image = "Image", file = "File"
    public var id: String { rawValue }
    public var title: String { "New \(rawValue)" }
}

public struct AddBookmarkItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    public let creationKind: CreationKind
    @State private var title: String = ""
    @State private var urlString: String = ""
    @State private var noteContent: String = ""
    @State private var selectedCategory: SmartCategory = .all
    @State private var isStarred: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var showFilePicker: Bool = false
    @State private var fileName: String?
    @State private var fileSize: Int64?
    @State private var fileData: Data?

    public init(creationKind: CreationKind) { self.creationKind = creationKind }

    private var isValid: Bool {
        switch creationKind {
        case .link: !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .note: !noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .image: imageData != nil
        case .file: fileData != nil
        }
    }

    public var body: some View {
        NavigationStack {
            Form {
                MediaPickerDetailsSection(kind: creationKind, title: $title, urlString: $urlString, photoItem: $photoItem, imageData: imageData, showFilePicker: $showFilePicker, fileName: fileName, fileSize: fileSize)
                if creationKind == .note {
                    Section("Note Content") { TextEditor(text: $noteContent).frame(minHeight: 120) }
                }
                Section("Organization") {
                    if creationKind != .note {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(SmartCategory.allCases.filter { $0 != .trash }) { Label($0.title, systemImage: $0.systemImage).tag($0) }
                        }
                    }
                    Toggle("Starred", isOn: $isStarred)
                }
            }
            .navigationTitle(creationKind.title).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { saveItem() }.disabled(!isValid) }
            }
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.item]) { handleFile($0) }
            .onChange(of: photoItem) { _, item in loadPhoto(item) }
        }
        .presentationDetents([.medium, .large])
    }

    private func loadPhoto(_ item: PhotosPickerItem?) {
        Task {
            guard let data = try? await item?.loadTransferable(type: Data.self) else { return }
            await MainActor.run {
                self.imageData = data
                if title.isEmpty { self.title = "Photo \(Date().formatted(date: .abbreviated, time: .shortened))" }
            }
        }
    }

    private func handleFile(_ result: Result<URL, Error>) {
        guard let url = try? result.get(), url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }
        let data = try? Data(contentsOf: url)
        self.fileData = data
        self.fileName = url.lastPathComponent
        self.fileSize = Int64((try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? data?.count ?? 0)
        if title.isEmpty { self.title = url.deletingPathExtension().lastPathComponent }
    }

    private func saveItem() {
        let defaultTitle = creationKind == .link ? (URL(string: urlString)?.host() ?? "Link") : "New \(creationKind.rawValue)"
        let finalTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? defaultTitle : title
        let item = BookmarkItem(title: finalTitle, contentURL: creationKind == .link ? urlString : nil, noteContent: creationKind == .note ? noteContent : nil, imageData: imageData, fileData: fileData, fileName: fileName, fileSize: fileSize, category: selectedCategory, kind: ContentKind(rawValue: creationKind.rawValue.lowercased()) ?? .link, isStarred: isStarred)
        modelContext.insert(item)
        dismiss()
    }
}
