import SwiftUI

public enum ContentKind: String, CaseIterable, Identifiable, Sendable {
    case link
    case note
    case image
    case file

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .link: "Links"
        case .note: "Notes"
        case .image: "Images"
        case .file: "Files"
        }
    }

    public var systemImage: String {
        switch self {
        case .link: "link"
        case .note: "note.text"
        case .image: "photo"
        case .file: "doc"
        }
    }

    public var colorTint: Color {
        switch self {
        case .link: .blue
        case .note: .orange
        case .image: .green
        case .file: .purple
        }
    }
}
