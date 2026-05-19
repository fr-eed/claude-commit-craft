# Phase 3: Build the plan

## Self-check the titles

Before showing any plan to the user, run two passes against the title rules below:

1. **Multi-concern scan.** Scan for `and`, `+`, `;`, or `,`. If found:
   - Umbrella term covers it ("scaffolding" covers "scaffolding and deps"): drop the redundant phrase.
   - Two real concerns: go back to Phase 2 and split.
2. **Weak-verb scan.** If a title starts with `Update <X>`, pick a sharper verb from the verb-selection table.

The user should never see a plan with `and` in any title, nor a plan starting with `Update <semantic thing>`.
