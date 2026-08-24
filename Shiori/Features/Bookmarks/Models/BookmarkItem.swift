import Foundation

public struct BookmarkItem: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var url: String
    public var category: SmartCategory
    public var kind: ContentKind
    public var isStarred: Bool
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        url: String,
        category: SmartCategory = .all,
        kind: ContentKind = .link,
        isStarred: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.url = url
        self.category = category
        self.kind = kind
        self.isStarred = isStarred
        self.createdAt = createdAt
    }

    public var host: String {
        URL(string: url)?.host() ?? url
    }

    public static let sampleData: [BookmarkItem] = [
        BookmarkItem(
            title: "Apple Developer Documentation",
            url: "https://developer.apple.com",
            category: .all,
            kind: .link,
            isStarred: true
        ),
        BookmarkItem(
            title: "Human Interface Guidelines",
            url: "https://developer.apple.com/design/human-interface-guidelines",
            category: .all,
            kind: .link,
            isStarred: false
        ),
        BookmarkItem(
            title: "SwiftUI Architecture Notes",
            url: "https://swift.org",
            category: .unsorted,
            kind: .note,
            isStarred: true
        )
    ]
}
