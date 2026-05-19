# Phase 5: Execute

For each approved commit in order:

1. **Stage exactly the files in that commit**, never `git add .` or `git add -A`:
   ```
   git add path/to/file.py path/to/other.py
   ```
   For hunk-level splits, use `git add -p` with prepared input or interactively guide the user.

2. **Commit via HEREDOC** to preserve formatting:
   ```bash
   git commit -m "$(cat <<'EOF'
   <title>

   <body if any>
   EOF
   )"
   ```

3. **Verify**: `git log -1 --pretty=oneline` and report the SHA plus title.

4. If a commit fails (pre-commit hook): STOP. Report the failure verbatim, do not retry, do not pass `--no-verify`. Tell the user the hook output and ask how they want to proceed.

After all commits land, show:
```
git log --oneline -<N>
```
Where N is the number of commits just created. End there.
