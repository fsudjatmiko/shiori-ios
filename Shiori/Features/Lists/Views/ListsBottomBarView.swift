import SwiftUI

public struct ListsBottomBarView: View {
    public var onSettingsTap: () -> Void = {}
    public var onOpenQuicklyTap: () -> Void = {}
    public var onNewSmartList: () -> Void = {}
    public var onNewTag: () -> Void = {}
    public var onNewFolder: () -> Void = {}

    public init(
        onSettingsTap: @escaping () -> Void = {},
        onOpenQuicklyTap: @escaping () -> Void = {},
        onNewSmartList: @escaping () -> Void = {},
        onNewTag: @escaping () -> Void = {},
        onNewFolder: @escaping () -> Void = {}
    ) {
        self.onSettingsTap = onSettingsTap
        self.onOpenQuicklyTap = onOpenQuicklyTap
        self.onNewSmartList = onNewSmartList
        self.onNewTag = onNewTag
        self.onNewFolder = onNewFolder
    }

    public var body: some View {
        HStack {
            Button(action: onSettingsTap) {
                Image(systemName: "gearshape")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }

            Spacer()

            Button(action: onOpenQuicklyTap) {
                Image(systemName: "location.north")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }

            Spacer()

            Menu {
                Button(action: onNewSmartList) {
                    Label("New Smart List", systemImage: "sparkles")
                }
                Button(action: onNewTag) {
                    Label("New Tag", systemImage: "tag")
                }
                Button(action: onNewFolder) {
                    Label("New Folder", systemImage: "folder")
                }
            } label: {
                Image(systemName: "plus")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }
}
