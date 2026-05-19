# Phase 1: Read the current state

Run in parallel:
- `git rev-parse --abbrev-ref HEAD`: current branch
- `basename "$(git rev-parse --show-toplevel)"`: repo name (basename of the working tree root)
- `git status`: what is staged, unstaged, untracked
- `git diff`: unstaged changes
- `git diff --cached`: staged changes
- `git log -5 --oneline`: recent commit style for context
- `git config user.name && git config user.email`: confirm authorship

If the working tree is clean: report "nothing to commit" and stop.

If `git rev-parse --abbrev-ref HEAD` returns `HEAD` (detached HEAD): refuse to commit. Tell the user to check out a branch first; committing in detached HEAD silently strands commits.

If on `main` or `master`: warn the user explicitly before proceeding. Don't create commits on main without acknowledgment.
