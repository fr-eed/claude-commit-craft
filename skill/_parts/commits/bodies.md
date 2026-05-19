## Body rules

When a commit needs a body (multi-component change, or non-obvious why), format as a bullet list:

- Each bullet is one change, starting with a present-tense verb. No "and"s within a bullet.
- Group related items inside ONE bullet using a colon (`Declare runtime deps: jax, numpy, pyyaml`) rather than splitting into seven micro-bullets.
- Wrap bullet lines at ~72 chars for `git log` readability.
- Blank line between title and body.

Skip the body for genuinely trivial commits (single-file typo fix, one-line tweak with obvious why).
