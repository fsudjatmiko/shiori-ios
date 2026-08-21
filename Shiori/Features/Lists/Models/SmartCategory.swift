import SwiftUI

public enum SmartCategory: String, CaseIterable, Identifiable, Sendable {
    case all
    case starred
    case untagged
    case unsorted
    case today
    case trash

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .all: "All Links"
        case .starred: "Starred"
        case .untagged: "Untagged"
        case .unsorted: "Inbox"
        case .today: "Today"
        case .trash: "Trash"
        }
    }

    public var systemImage: String {
        switch self {
        case .all: "tray.full.fill"
        case .starred: "star.fill"
        case .untagged: "tag.slash.fill"
        case .unsorted: "archivebox.fill"
        case .today: "calendar"
        case .trash: "trash.fill"
        }
    }

    public var colorTint: Color {
        switch self {
        case .all: .blue
        case .starred: .yellow
        case .untagged: .purple
        case .unsorted: .blue
        case .today: .green
        case .trash: .secondary
        }
    }

    public var count: Int {
        0
    }
}
