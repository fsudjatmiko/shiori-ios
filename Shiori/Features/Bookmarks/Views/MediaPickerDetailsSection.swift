import SwiftUI
import PhotosUI

struct MediaPickerDetailsSection: View {
    let kind: CreationKind
    @Binding var title: String
    @Binding var urlString: String
    @Binding var photoItem: PhotosPickerItem?
    let imageData: Data?
    @Binding var showFilePicker: Bool
    let fileName: String?
    let fileSize: Int64?

    var body: some View {
        Section("Details") {
            TextField("Title", text: $title)
            switch kind {
            case .link:
                TextField("https://example.com", text: $urlString)
                    .keyboardType(.URL).textInputAutocapitalization(.never).autocorrectionDisabled()
                if let host = URL(string: urlString)?.host(), !host.isEmpty {
                    LabeledContent("Domain", value: host)
                }
            case .image:
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Label("Choose from Photos", systemImage: "photo.badge.plus")
                }
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(maxHeight: 120).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            case .file:
                Button { showFilePicker = true } label: { Label("Select File", systemImage: "doc.badge.plus") }
                if let fileName, let fileSize {
                    LabeledContent(fileName, value: ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file))
                }
            case .note: EmptyView()
            }
        }
    }
}
