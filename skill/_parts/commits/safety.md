# Safety rules

- **NEVER** commit `.env`, `secrets.*`, `*.key`, `*.pem`, or files matching credential patterns. Check the diff for `API_KEY=`, `SECRET=`, `password =` before staging. If found, ask before including.
- **NEVER** rewrite history (no `git commit --amend`, no `git rebase`). This skill creates new commits only. Rewriting is `commit-review`'s job.
- If you see a change you don't understand, ask before grouping it.
