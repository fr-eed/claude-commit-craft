## Text-mode presenter

Print each proposed commit numbered, with title, files (path + status flag M/A/D/R + line counts), and body bullets. End with: "Approve all, edit a message, move a file, merge/split commits, or single-commit?"

Accept these edit forms:

- "approve" / "yes" / "ok" / "lgtm": proceed to Phase 5
- "edit 2: <new title>": update commit 2's title, re-print the plan
- "body 1: <text>": add/replace body of commit 1
- "move file.py to 1": reassign file
- "merge 1 and 2": collapse two commits, ask for combined title
- "split 2 by file": propose further sub-split for commit 2
- "just one: <title>": bail on the split, single commit with that title
- "cancel" / "abort": stop, do nothing

Loop until explicit approval.

**To rebuild the dialog binary**, run `make build` in the repo, then `make install`.
