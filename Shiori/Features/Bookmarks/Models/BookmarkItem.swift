import Foundation

public struct BookmarkItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var subtitle: String
    public var url: String
    public var category: SmartCategory
    public var kind: ContentKind
    public var iconName: String
    public var previewImageName: String?
    public var isStarred: Bool
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        url: String,
        category: SmartCategory = .all,
        kind: ContentKind = .link,
        iconName: String? = nil,
        previewImageName: String? = nil,
        isStarred: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle.isEmpty ? (URL(string: url)?.host() ?? url) : subtitle
        self.url = url
        self.category = category
        self.kind = kind
        self.iconName = iconName ?? kind.systemImage
        self.previewImageName = previewImageName
        self.isStarred = isStarred
        self.createdAt = createdAt
    }

    public var host: String {
        URL(string: url)?.host() ?? url
    }

    public static let sampleData: [BookmarkItem] = [
        BookmarkItem(
            title: "Apple Developer Documentation",
            subtitle: "developer.apple.com • 1 min ago",
            url: "https://developer.apple.com",
            category: .all,
            kind: .link,
            iconName: "globe",
            isStarred: true
        ),
        BookmarkItem(
            title: "Human Interface Guidelines",
            subtitle: "developer.apple.com • 15 min ago",
            url: "https://developer.apple.com/design/human-interface-guidelines",
            category: .all,
            kind: .link,
            iconName: "safari",
            isStarred: false
        ),
        BookmarkItem(
            title: "SwiftUI Architecture Notes",
            subtitle: "248 words • 33 min ago",
            url: "https://swift.org",
            category: .unsorted,
            kind: .note,
            iconName: "note.text",
            isStarred: true
        ),
        BookmarkItem(
            title: "Design_Specs_Hero_Mockup.png",
            subtitle: "PNG image • 3.6 MB • 2 hrs ago",
            url: "file:///Design_Specs_Hero_Mockup.png",
            category: .all,
            kind: .image,
            iconName: "photo",
            previewImageName: "photo.artframe",
            isStarred: false
        ),
        BookmarkItem(
            title: "Architecture_Overview_v2.pdf",
            subtitle: "PDF document • 1.2 MB • yesterday",
            url: "file:///Architecture_Overview_v2.pdf",
            category: .all,
            kind: .file,
            iconName: "doc.text.fill",
            isStarred: false
        )
    ]
}
