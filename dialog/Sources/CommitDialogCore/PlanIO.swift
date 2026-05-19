import Foundation

// Pure encode/decode for the dialog protocol. No I/O side-effects.
// Output is minified with raw slashes (no `\/` escapes) to stay token-efficient.
public enum PlanIO {
    public static func parse(from data: Data) throws -> CommitPlan {
        try JSONDecoder().decode(CommitPlan.self, from: data)
    }

    public static func encode(_ plan: CommitPlan) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        return try encoder.encode(plan)
    }
}
