import SwiftUI

// Always-visible strip showing where the commits will land. Useful when multiple
// Claude sessions are open across different repos and the panel floats above all Spaces.
struct ContextHeader: View {
    let repo: String?
    let branch: String?

    var body: some View {
        HStack(spacing: 6) {
            if let repo {
                Text(repo)
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                Text("/")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            if let branch {
                Text(branch)
                    .font(.system(.caption, design: .monospaced))
            }
            Spacer()
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 6)
    }
}
