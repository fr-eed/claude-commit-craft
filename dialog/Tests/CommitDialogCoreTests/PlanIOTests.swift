import XCTest
import CommitDialogCore

final class PlanIOTests: XCTestCase {
    func test_roundTrip_preservesAllFields() throws {
        let original = CommitPlan(
            commits: [
                CommitEntry(
                    title: "Add commit-craft scaffolding",
                    body: "- Pin Python 3.12\n- Add Makefile / install / dev targets",
                    files: ["commit-craft/SKILL.md", "Makefile", "README.md"]
                )
            ],
            approved: true,
            branch: "feature/auth",
            repo: "claude-commit-craft"
        )
        let data = try PlanIO.encode(original)
        let decoded = try PlanIO.parse(from: data)
        XCTAssertEqual(decoded, original)
    }

    func test_parse_throwsOnMalformedJSON() {
        let malformed = Data("{not-valid-json".utf8)
        XCTAssertThrowsError(try PlanIO.parse(from: malformed))
    }

    func test_encode_outputIsMinified() throws {
        // Catches accidental reversion to .prettyPrinted: pretty output contains
        // newlines and two-space indentation. Minified output has neither.
        let plan = CommitPlan(
            commits: [CommitEntry(title: "t", body: "b", files: ["a/b.swift"])],
            approved: nil,
            branch: "main"
        )
        let data = try PlanIO.encode(plan)
        let json = String(decoding: data, as: UTF8.self)
        XCTAssertFalse(json.contains("\n"), "minified output must not contain newlines")
        XCTAssertFalse(json.contains("  "), "minified output must not contain indentation")
        XCTAssertFalse(json.contains("\\/"), ".withoutEscapingSlashes must keep slashes raw")
    }
}
