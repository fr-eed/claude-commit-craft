import SwiftUI

// Shown above the tab bar when the user is about to commit on a protected branch.
// Defense-in-depth: SKILL.md already tells Claude to warn, but a visible banner in the
// final-confirm UI removes any chance of a silent main/master commit.
struct BranchWarning: View {
    let branch: String

    var body: some View {
        HStack(spacing: 0) {
            Text("Committing directly to ")
                .font(.system(.caption, weight: .medium))
            Text(branch)
                .font(.system(.caption, design: .monospaced, weight: .bold))
            Text(". Confirm this is intentional before Commit All.")
                .font(.system(.caption, weight: .medium))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.62, green: 0.22, blue: 0.04).opacity(0.92))
    }
}
