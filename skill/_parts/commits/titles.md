## Title rules

- Imperative mood: `Add`, `Fix`, `Refactor`, `Remove`, `Pin`, `Bind`. NEVER past tense (`Added`, `Updated`, `Fixed`).
- Capitalized first word (exception: Conventional-Commits prefixes like `feat:`).
- No trailing period. Length ≤ 60 chars (hard cap 72).
- Specific: describe the change, not the file. `Document install steps`, not `Update README.md`.
- Single concern: NO `and`, `+`, `;`, or `,` connecting multiple changes. If the title needs one, split the commit.

## Verb selection (avoid `Update <anything>`)

| Operation | Verb |
| --- | --- |
| Replacing existing content | `Rewrite`, `Replace` |
| Adding new content | `Add`, `Append`, `Prepend`, `Extend` |
| Changing a value or version | `Bump`, `Pin`, `Switch`, `Set` |
| Reworking structure, no behavior change | `Refactor`, `Restructure` |
| Narrow patch | `Tweak`, `Adjust`, `Tune` |

`Update` is only acceptable for non-semantic refreshes (`Update lockfile`, `Update copyright year`). If you find yourself writing `Update <semantic thing>`, pick the verb that names the operation.

## Banned title patterns

Reject and propose a concrete alternative:

- `Update <filename>` or `Update <semantic thing>`. Use a sharper verb from the table.
- `wip`, `WIP`, `fix` (alone), `fixes` (alone), `stuff`, `asdf`.
- `Initial commit` for non-trivial commits.
- Category-only: `bugfixes`, `UI improvements`, `UX patch`, `Styling fix`, `Small refactoring`.
- Past tense (`Added X`), lowercase first word (unless scope prefix), trailing period, percentage scopes (`Refactored 50% of X`).
- Multi-concern joined by `and`, `+`, `;`, or `,`.
