import Foundation
import SwiftData

@Model
public final class BookmarkItem {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var contentURL: String?
    public var noteContent: String?
    public var imageData: Data?
    public var fileData: Data?
    public var fileName: String?
    public var fileSize: Int64?
    public var categoryRaw: String
    public var kindRaw: String
    public var isStarred: Bool
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        contentURL: String? = nil,
        noteContent: String? = nil,
        imageData: Data? = nil,
        fileData: Data? = nil,
        fileName: String? = nil,
        fileSize: Int64? = nil,
        category: SmartCategory = .all,
        kind: ContentKind = .link,
        isStarred: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.contentURL = contentURL
        self.noteContent = noteContent
        self.imageData = imageData
        self.fileData = fileData
        self.fileName = fileName
        self.fileSize = fileSize
        self.categoryRaw = category.rawValue
        self.kindRaw = kind.rawValue
        self.isStarred = isStarred
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public var category: SmartCategory {
        get { SmartCategory(rawValue: categoryRaw) ?? .all }
        set { categoryRaw = newValue.rawValue }
    }

    public var kind: ContentKind {
        get { ContentKind(rawValue: kindRaw) ?? .link }
        set { kindRaw = newValue.rawValue }
    }

    public var formattedSubtitle: String {
        switch kind {
        case .link:
            if let contentURL, let host = URL(string: contentURL)?.host() {
                return "\(host) • \(createdAt.formatted(.relative(presentation: .named)))"
            }
            return createdAt.formatted(.relative(presentation: .named))
        case .note:
            let wordCount = (noteContent ?? title).split { $0.isWhitespace }.count
            return "\(wordCount) \(wordCount == 1 ? "word" : "words") • \(createdAt.formatted(.relative(presentation: .named)))"
        case .image:
            let sizeStr = ByteCountFormatter.string(fromByteCount: fileSize ?? Int64(imageData?.count ?? 0), countStyle: .file)
            return "\(fileName ?? "Image") • \(sizeStr)"
        case .file:
            let sizeStr = ByteCountFormatter.string(fromByteCount: fileSize ?? Int64(fileData?.count ?? 0), countStyle: .file)
            return "\(fileName ?? "File") • \(sizeStr)"
        }
    }

    public static let sampleData: [BookmarkItem] = [
        BookmarkItem(
            title: "Apple Developer Documentation",
            contentURL: "https://developer.apple.com",
            category: .all,
            kind: .link,
            isStarred: true
        ),
        BookmarkItem(
            title: "Human Interface Guidelines",
            contentURL: "https://developer.apple.com/design/human-interface-guidelines",
            category: .all,
            kind: .link,
            isStarred: false
        ),
        BookmarkItem(
            title: "SwiftUI Architecture Notes",
            noteContent: "A note documenting SwiftUI and SwiftData architectural best practices.",
            category: .unsorted,
            kind: .note,
            isStarred: true
        ),
        BookmarkItem(
            title: "Design_Specs_Hero_Mockup.png",
            fileName: "Design_Specs_Hero_Mockup.png",
            fileSize: 3774873,
            category: .all,
            kind: .image,
            isStarred: false
        ),
        BookmarkItem(
            title: "Architecture_Overview_v2.pdf",
            fileName: "Architecture_Overview_v2.pdf",
            fileSize: 1258291,
            category: .all,
            kind: .file,
            isStarred: false
        )
    ]
}
