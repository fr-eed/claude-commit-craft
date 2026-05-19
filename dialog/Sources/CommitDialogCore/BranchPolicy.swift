import Foundation

// Branches the dialog flags as risky before allowing commits to proceed.
// Defense-in-depth alongside SKILL.md's prose-level warning.
public enum BranchPolicy {
    public static let protectedNames: Set<String> = ["main", "master"]

    public static func isProtected(_ branch: String?) -> Bool {
        guard let name = branch?.lowercased(), !name.isEmpty else { return false }
        return protectedNames.contains(name)
    }
}
