import Foundation
import SwiftUI
import CommitDialogCore

// Observable state container the SwiftUI views bind to.
// Keeps the editable `commits` array, plus the immutable `branch` (used to drive the
// protected-branch banner) and the optional output path for manual-testing mode.
@MainActor
final class PlanStore: ObservableObject {
    @Published var commits: [CommitEntry]
    let branch: String?
    let repo: String?
    let outputPath: String?

    init(initial: [CommitEntry], branch: String?, repo: String?, outputPath: String?) {
        self.commits = initial
        self.branch = branch
        self.repo = repo
        self.outputPath = outputPath
    }

    func write(approved: Bool) {
        let plan = CommitPlan(commits: commits, approved: approved, branch: branch, repo: repo)
        let data: Data
        do {
            data = try PlanIO.encode(plan)
        } catch {
            FileHandle.standardError.write(Data("encode failed: \(error)\n".utf8))
            return
        }

        if let path = outputPath {
            try? data.write(to: URL(fileURLWithPath: path))
        } else {
            FileHandle.standardOutput.write(data)
            FileHandle.standardOutput.write(Data("\n".utf8))
        }
    }
}
