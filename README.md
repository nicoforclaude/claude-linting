# claude-linting

Linting and code quality plugins for Claude Code.

## Plugins

### 🧹 linting

Auto-detects and runs project linting with safe fixes. Works with any ESLint setup.

**Features:**
- Auto-detects linting setup (ESLint, package manager)
- Caches configuration for performance
- Safe auto-fix (layout-only changes)
- PostToolUse hook for automatic linting on Edit/Write
- Commands: `/linting_fix`, `/linting_check`
- Agent: `linter-agent`

**Works with:**
- Any ESLint configuration (Antfu, AirBnB, Standard, etc.)
- TypeScript, JavaScript, JSX, TSX projects
- Yarn, npm, pnpm

---

### 📏 antfu

Enforces @antfu/eslint-config conventions and patterns.

**Features:**
- Single quotes enforcement
- 2-space indentation
- Type-only imports preference
- Console usage rules (frontend vs backend)
- Svelte-specific handling
- Exception handling for imported code (shadcn/ui)

**Skill:** `antfu:compliance`

---

## Installation

```bash
# Install both plugins (for Antfu projects)
claude plugin install nico-dev/claude-linting

# Or install individual plugins
claude plugin enable linting
claude plugin enable antfu
```

## Usage

### Linting Commands

```bash
# Check linting without fixing
/linting_check

# Fix safe issues (changed files)
/linting_fix

# Check entire repository
/linting_check --all
```

### Automatic Hook

The `linting` plugin includes a PostToolUse hook that automatically runs ESLint with layout fixes after editing TS/JS files. Enable in settings:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "path/to/plugins/linting/hooks/after-edit-lint.sh"
          }
        ]
      }
    ]
  }
}
```

### Antfu Skill

For projects using @antfu/eslint-config, the `antfu:compliance` skill provides guidance on Antfu-specific conventions.

---

## Author

Nico
