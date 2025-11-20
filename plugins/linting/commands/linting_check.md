---
description: "Run ESLint in check-only mode (no auto-fix), produce chat summary. Two modes: changed files (default) or whole repo (--all)."
argument-hint: "[--all]"
# Safe tool allowlist; no command substitution is used.
allowed-tools: Bash(yarn:*), Bash(pnpm:*), Bash(npm:*), Bash(npx:*), Bash(corepack:*), Bash(node:*), Bash(git status:*), Bash(git diff:*), Bash(git ls-files:*), Bash(git rev-parse:*), Bash(git show:*), Bash(cat:*)
---

# 🔍 Linting Check — Report Only (No Auto-Fix)

You are **linting‑check‑claude**. Your job is to **identify and report** ESLint issues **without making any changes**. This is a read-only linting check that produces a **clear chat‑only summary**. **Do not write any report files** and **do not modify any code**.

## Scope (two options only)

- **Default:** lint **locally changed files** (staged + unstaged, new + modified) relative to the working tree.
- **`--all`:** lint the **entire repository**.

## Inputs & Guidance

- Follow project rules in @CLAUDE.md.
- Respect the project's workflow: use `yarn lint` command.
- Prefer the project's package scripts; if missing, fall back to direct ESLint commands via `npx eslint`.
- Use **corepack** when available to select the correct package manager.

## Data Collection (pre‑run; no $())

Gather minimal context for you to parse in chat:

- Package.json: !`cat package.json`
- Current branch & status: !`git status --porcelain=v1 -b`
- Staged changed files: !`git diff --name-only --staged`
- Unstaged changed files vs HEAD: !`git diff --name-only HEAD`
- Modified tracked files: !`git ls-files -m`
- Untracked files (exclude standard): !`git ls-files -o --exclude-standard`

**Build the target file list as follows:**

- If `--all` not provided: union of staged + unstaged + modified + untracked; deduplicate; filter to ESLint‑handled extensions: `js,jsx,ts,tsx,mjs,cjs,vue,svelte`.
- Always exclude generated/build directories: `node_modules`, `dist`, `build`, `.next`, `.nuxt`, `coverage`, `out`.
- If the resulting list is empty, say so and exit cleanly.

## Check Flow (no modifications)

1. **Identify Issues**
   - If a `lint` script exists, run it on the scoped files: `yarn run lint -- -f json` (or pnpm/npm analogs), passing file list when in "changed files" mode. If script runs repo‑wide, that's acceptable in `--all` mode.
   - If no script, run: `npx eslint <files> -f json --max-warnings=0`.
   - Parse the **JSON output from stdout** (do not write reports). Compute totals by severity, **top rules**, **top files**, and gather **3–5 representative examples** with suggested rewrites.
   - **Print a comprehensive "Issues Found" summary in chat.**

2. **DO NOT Auto-Fix**
   - This is a check-only command
   - No code modifications should be made
   - Report what WOULD be fixed if /linting_fix were run

## Required Chat Output (structure)

**A. Summary — Issues Found:**

- Total files scanned; total problems; error vs warning counts.
- Top rules (name, count, brief why it occurs here).
- Top files by count with `file:line → rule` bullets.
- 3–5 representative examples (short snippet → suggested fix).

**B. Breakdown by Category:**

- **Auto-fixable:** Issues that could be fixed by /linting_fix
- **Manual fixes needed:** Issues requiring human intervention

**C. Next Steps:**

- If auto-fixable issues exist: "Run `/linting_fix` to automatically fix safe issues"
- If manual fixes needed: List specific issues with file:line references
- If no issues: "✓ No linting issues found"

## Output Format Examples

### Clean State

```
✓ Linting Check Complete

Scanned: 12 files
Issues: 0 errors, 0 warnings

No linting issues found.
```

### Issues Found

```
⚠ Linting Check Complete

Scanned: 8 files
Issues: 3 errors, 7 warnings

Top Rules:
  • @typescript-eslint/no-unused-vars (5 occurrences)
  • quotes (3 occurrences - should use single quotes)
  • indent (2 occurrences - should use 2 spaces)

Top Files:
  • services/webapp/src/components/Board.svelte (4 issues)
  • packages/shared/utils.ts (3 issues)
  • services/api/routes/game.ts (3 issues)

Auto-fixable (7 issues):
  ✓ Can be fixed automatically with /linting_fix
  • quotes (3) - convert to single quotes
  • indent (2) - fix indentation
  • unused-import (2) - remove unused imports

Manual fixes needed (3 errors):
  ✗ services/webapp/src/components/Board.svelte:42
    console.log not allowed in this file

  ✗ packages/shared/utils.ts:18
    Unused variable 'result' (add underscore prefix or remove)

Next steps:
  1. Run /linting_fix to auto-fix 7 safe issues
  2. Manually address 3 remaining errors
```

## Guardrails

- **No code modifications** — this is read-only check
- **No report files** — show everything relevant **in chat**
- **No commits or pushes** — this is a non-destructive operation
- Respect ignore files and ESLint config resolution
- Focus on clear, actionable reporting
