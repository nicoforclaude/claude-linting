---
description: "Run ESLint, fix safely, and produce a chat-only summary (no files). Two modes: changed files (default) or whole repo (--all)."
argument-hint: "[--all]"
# Safe tool allowlist; no command substitution is used.
allowed-tools: Bash(yarn:*), Bash(pnpm:*), Bash(npm:*), Bash(npx:*), Bash(corepack:*), Bash(node:*), Bash(git status:*), Bash(git diff:*), Bash(git ls-files:*), Bash(git rev-parse:*), Bash(git show:*), Bash(cat:*)
---

# 🧹 Fix Linting — Chat‑Only Summary (No Files)

You are **fix‑linting‑claude**. Your job is to **identify, safely fix, and verify** ESLint issues while producing a **clear chat‑only summary**. **Do not write any report files** and **do not commit** unless the user explicitly confirms.

## Scope (two options only)

- **Default:** lint **locally changed files** (staged + unstaged, new + modified) relative to the working tree.
- **`--all`:** lint the **entire repository**.

## Inputs & Guidance

- Follow project rules in @CLAUDE.md.
- Respect the user’s established workflow: `yarn lint`, `yarn lint:fix:safe`, then manual fixes if needed. fileciteturn0file0
- Prefer the project’s package scripts; if missing, fall back to direct ESLint commands via `npx eslint`.
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

## Lint/Fix/Verify Flow (no artifact writes)

1. **Identify (BEFORE)**
   - If a `lint` script exists, run it on the scoped files: `yarn run lint -- -f json` (or pnpm/npm analogs), passing file list when in “changed files” mode. If script runs repo‑wide, that’s acceptable in `--all` mode.
   - If no script, run: `npx eslint <files> -f json --max-warnings=0`.
   - Parse the **JSON output from stdout** (do not write reports). Compute totals by severity, **top rules**, **top files**, and gather **3–5 representative examples** with suggested rewrites.
   - **Print a concise “What was wrong” summary in chat.**

2. **Safe Fix**
   - Preferred: `yarn run lint:fix:safe` (or workspace‑wide equivalent) — must restrict to non‑behavioral fixes.
   - Fallback: `npx eslint <files> --fix --fix-type [layout,suggestion]`.
   - If no lintable files in changed mode, skip fix and report “nothing to do.”

3. **Verify (AFTER SAFE FIX)**
   - Re‑run the identify command (same scope) with `-f json` to stdout.
   - Parse output and **print a delta summary**: before vs after counts, **resolved rules** and **remaining blockers** with `file:line → rule` bullets.

4. **Manual Fixes (only with confirmation)**
   - If blockers remain, propose **small, concrete code edits** per file (show unified diff hunks).
   - Ask: **“Proceed to apply manual fixes now?”** If the user says **yes**, apply edits in small commits. If **no**, stop and print the list of remaining items.

## Required Chat Output (structure)

**A. Summary — What was wrong (BEFORE):**

- Total files scanned; total problems; error vs warning counts.
- Top rules (name, count, brief why it occurs here).
- Top files by count.
- 3–5 representative examples (short snippet → suggested fix).

**B. Summary — After safe fixes:**

- Totals before vs after; which rules were resolved; which remain, with `file:line` bullets.

**C. Next step prompt:**

- “**Proceed to apply manual fixes now?** (yes/no)”

## Guardrails

- **No report files**; show everything relevant **in chat**.
- **No commits or pushes** unless the user answers **yes** to the manual‑fix prompt.
- Avoid behavior‑changing refactors during “safe fix.”
- Respect ignore files and ESLint config resolution.
