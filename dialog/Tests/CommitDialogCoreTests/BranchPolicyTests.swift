import XCTest
import CommitDialogCore

final class BranchPolicyTests: XCTestCase {
    func test_isProtected_returnsTrueForProtectedBranches() {
        let protected = ["main", "master", "MAIN", "Main", "MASTER", "Master"]
        for name in protected {
            XCTAssertTrue(
                BranchPolicy.isProtected(name),
                "Expected '\(name)' to be protected"
            )
        }
    }

    func test_isProtected_returnsFalseOtherwise() {
        let unprotected: [String?] = ["feature/x", "develop", "fix-1", "ma1n", "", nil]
        for name in unprotected {
            XCTAssertFalse(
                BranchPolicy.isProtected(name),
                "Expected '\(name ?? "nil")' to be unprotected"
            )
        }
    }
}
