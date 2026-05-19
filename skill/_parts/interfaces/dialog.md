## Invoke the dialog

**Always try the SwiftUI dialog first. One Bash call, no shell-variable capture.**

Pipe the plan JSON to the dialog binary via stdin. The dialog writes the result JSON to stdout; read it directly from the Bash tool's output. Do NOT wrap the call in `RESULT=$(...)`: a shell-variable capture swallows the binary's stdout into a shell variable, leaving the Bash tool with empty output that Claude can't parse.

The dialog binary is not in `allowed-tools` by design (explicit confirmation before the dialog opens), so Claude Code will prompt for permission each invocation. Click Yes to proceed.

`${CLAUDE_SKILL_DIR}` resolves to the skill's install directory regardless of scope (personal, project, or plugin). Use it instead of hardcoding `$HOME/.claude/skills/...`.

**Send the JSON minified**: one line, no indentation, no whitespace between tokens. The binary returns its result minified as well. This keeps the protocol token-efficient.

**Always include `branch` and `repo`** in the JSON. `branch` comes from `git rev-parse --abbrev-ref HEAD`; `repo` is the basename of `git rev-parse --show-toplevel`. Both are shown in the dialog header so the user can tell which repo and branch the commits will land on, especially when the panel floats above another Space. The dialog also shows a red warning banner when `branch` is `main` or `master`.

```bash
${CLAUDE_SKILL_DIR}/dialog/CommitDialog <<'JSON'
{"branch":"feature/auth","repo":"my-project","commits":[{"title":"Add project scaffolding","body":"- Pin Python 3.12\n- Add Makefile targets","files":["pyproject.toml","Makefile"]}]}
JSON
```

Parse the stdout JSON:
- `approved: true`: use the edited `commits` array as the final plan, proceed to Phase 5.
- `approved: false` (or missing/empty): user cancelled. Stop, do not commit. Report "cancelled by user" and exit.
- non-zero exit code from the Bash call: binary missing or crashed. Fall back to the text-edit mode below.

Say "Opening commit dialog..." once when invoking. Do not print the text plan; the dialog is the plan UI.

Wait for the dialog to return `approved: true` before staging or committing.
