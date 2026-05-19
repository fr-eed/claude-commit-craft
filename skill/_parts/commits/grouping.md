## Grouping heuristics

- **New feature**: source file plus its tests plus its config -> ONE commit.
- **Refactor that enables a feature**: separate commit BEFORE the feature.
- **Bug fix discovered while building feature**: separate commit (unless trivially related).
- **Renames**: separate from functional changes. Mechanical edits accompanying a rename (import-path updates) can stay in the same commit; substantive edits to a renamed file should split.
- **Docs / README**: their own commit unless they directly accompany a specific feature being shipped in the same change.
- **Config / lint / build-system changes**: separate from feature work.
- **Multiple unrelated changes in one file**: split via `git add -p` (hunk-level staging).

## Edge cases that affect grouping

- **Only untracked files (no modifications)**: still propose the commit, but flag in the plan that all files are new. The user may have created them as a scratchpad.
- **Whitespace-only changes**: don't pad into their own commits. Fold whitespace-only hunks into the nearest functional commit. If the entire change is whitespace cleanup, keep it as one dedicated commit (`Normalize trailing whitespace`).
- **Generated files** (`*.lock`, `*-lock.json`, build outputs, generated bindings): warn before including. Keep generated files in a separate commit from the source change that caused them, so reverting either is independently meaningful.
- **Large diffs (>500 lines in one file)**: flag and suggest splitting by hunks via `git add -p`. Exception: a deleted or generated file legitimately changing as one unit.
