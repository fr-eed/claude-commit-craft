import Foundation

// JSON exchange types for the commit-craft dialog protocol.
// Claude writes a CommitPlan to stdin; binary writes the edited plan back with `approved` set.
// All payloads are minified.
public struct CommitPlan: Codable, Equatable {
    public var commits: [CommitEntry]
    public var approved: Bool?
    public var branch: String?
    public var repo: String?

    public init(
        commits: [CommitEntry],
        approved: Bool? = nil,
        branch: String? = nil,
        repo: String? = nil
    ) {
        self.commits = commits
        self.approved = approved
        self.branch = branch
        self.repo = repo
    }
}

public struct CommitEntry: Codable, Hashable {
    public var title: String
    public var body: String
    public var files: [String]

    public init(title: String, body: String, files: [String]) {
        self.title = title
        self.body = body
        self.files = files
    }
}
