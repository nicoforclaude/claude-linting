#!/usr/bin/env bash
# Minimal TS/JS auto-lint hook
# Only runs on .ts/.tsx/.js/.jsx files, uses npx eslint directly
# Only applies layout fixes (cosmetic: spacing, semicolons, etc.)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.toolInput.file_path // empty')

# Only .ts/.tsx/.js/.jsx files that exist
[[ "$FILE_PATH" =~ \.(ts|tsx|js|jsx)$ ]] && [[ -f "$FILE_PATH" ]] || exit 0

# Run ESLint with LAYOUT fixes only (cosmetic: spacing, semicolons, etc.)
# No suggestions (import reordering, etc.), no problem fixes (logic changes)
npx eslint "$FILE_PATH" --fix --fix-type layout --cache 2>/dev/null || true
exit 0
