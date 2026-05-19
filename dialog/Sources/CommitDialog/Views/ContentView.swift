import AppKit
import SwiftUI
import CommitDialogCore

struct ContentView: View {
    @EnvironmentObject var store: PlanStore
    @State private var selected: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ContextHeader(repo: store.repo, branch: store.branch)

            if let branchName = store.branch, BranchPolicy.isProtected(branchName) {
                BranchWarning(branch: branchName)
            }

            // Tab bar
            HStack(spacing: 4) {
                ForEach(store.commits.indices, id: \.self) { i in
                    Button(action: { selected = i }) {
                        Text("\(i + 1). \(store.commits[i].title.isEmpty ? "(untitled)" : store.commits[i].title)")
                            .lineLimit(1)
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selected == i ? Theme.accentSoft : Color.clear)
                            .foregroundStyle(selected == i ? Theme.accent : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 4)

            // Detail
            if store.commits.indices.contains(selected) {
                CommitTab(
                    entry: $store.commits[selected],
                    index: selected,
                    total: store.commits.count
                )
                // .id forces SwiftUI to recreate the subtree when the selection
                // changes. Without it, TextEditor caches its content and the
                // body field shows the previous commit's text on tab switch.
                .id(selected)
            }

            Divider().background(Theme.stroke)

            // Action bar
            HStack {
                Text("\(store.commits.count) commit\(store.commits.count == 1 ? "" : "s") will be created")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Cancel") {
                    store.write(approved: false)
                    NSApp.terminate(nil)
                }
                .keyboardShortcut(.cancelAction)
                .buttonStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundStyle(.secondary)

                Button("Commit All") {
                    store.write(approved: true)
                    NSApp.terminate(nil)
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .foregroundStyle(.white)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(14)
        }
        .frame(minWidth: 640, minHeight: 520)
        .background(
            ZStack {
                VisualEffectBackground(material: .hudWindow, blendingMode: .behindWindow)
                // Warm-dark overlay tinted toward the Anthropic palette.
                // Keeps content legible against any wallpaper / window behind.
                Color(red: 0x1A / 255, green: 0x14 / 255, blue: 0x12 / 255).opacity(0.55)
            }
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .tint(Theme.accent)
    }
}
