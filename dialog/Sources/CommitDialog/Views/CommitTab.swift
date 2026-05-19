import SwiftUI
import CommitDialogCore

struct CommitTab: View {
    @Binding var entry: CommitEntry
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Commit \(index + 1) of \(total)")
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(Theme.accent)
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 6) {
                Text("Title").font(.caption).foregroundStyle(.secondary)
                TextField("Imperative, single concern, no trailing period", text: $entry.title)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Body (optional)").font(.caption).foregroundStyle(.secondary)
                TextEditor(text: $entry.body)
                    .font(.system(.body, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .padding(6)
                    .background(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(minHeight: 140)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Files (\(entry.files.count))").font(.caption).foregroundStyle(.secondary)
                ScrollView {
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(entry.files, id: \.self) { path in
                            Text(path)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
                .background(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Theme.stroke, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(maxHeight: 110)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
}
