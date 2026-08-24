import SwiftUI

public struct UnifiedBottomPillTabBar: View {
    public var onNoteTap: () -> Void = {}
    public var onSearchTap: () -> Void = {}
    public var onImageTap: () -> Void = {}
    public var onFileTap: () -> Void = {}
    public var onSettingsTap: () -> Void = {}

    public init(
        onNoteTap: @escaping () -> Void = {},
        onSearchTap: @escaping () -> Void = {},
        onImageTap: @escaping () -> Void = {},
        onFileTap: @escaping () -> Void = {},
        onSettingsTap: @escaping () -> Void = {}
    ) {
        self.onNoteTap = onNoteTap
        self.onSearchTap = onSearchTap
        self.onImageTap = onImageTap
        self.onFileTap = onFileTap
        self.onSettingsTap = onSettingsTap
    }

    public var body: some View {
        HStack(spacing: 0) {
            tabItem(title: "Note", systemImage: "square.and.pencil", action: onNoteTap)
            tabItem(title: "Search", systemImage: "location.north", action: onSearchTap)
            tabItem(title: "Image", systemImage: "photo.on.rectangle.angled", action: onImageTap)
            tabItem(title: "File", systemImage: "doc", action: onFileTap)
            tabItem(title: "Settings", systemImage: "gearshape", action: onSettingsTap)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func tabItem(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: systemImage)
                    .font(.body.weight(.medium))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
