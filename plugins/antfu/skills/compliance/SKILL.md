---
name: antfu-compliance
description: Enforces @antfu/eslint-config rules including single quotes, 2-space indentation, type-only imports, and console usage restrictions. Use when working on lintable files (.ts,.js, .md, and other) in projects with Antfu ESLint configuration (check if lint config extends antfu).
---

when to implement this skill?
in all TS projects its default 
you can check if lint config extends antfu config,
then really rely on that skill

obviously it's not needed for non-TS (like Kotlin projects)



## Antfu ESLint Configuration Compliance

This project uses `@antfu/eslint-config` with specific customizations. Follow these rules strictly:

### Quote Usage

- **Use single quotes** for strings: `'hello'` not `"hello"`
- This is enforced by `stylistic.quotes: 'single'` in the ESLint config

### Indentation

- **Use 2 spaces** for indentation (no tabs)
- This is enforced by `stylistic.indent: 2` and `.prettierrc` settings

### Import Style

- **Prefer type-only imports** when importing types:
    - Good: `import type { User } from './types'`
    - Avoid: `import { User } from './types'` (when User is only used as a type)
- This is enforced by `@typescript-eslint/consistent-type-imports: 'warn'`

### Console Usage Rules

- **Frontend code** (`services/webapp/**`): Console usage is allowed
- **Backend/Server code**: Console usage is **forbidden** - use proper logging instead
- **Packages**: Only `console.error` is allowed
- **Test files**: All console methods are allowed

### Unused Variables

- **Svelte files** (`.svelte`): Unused variables are allowed (may be used in templates)
- **TypeScript files**: Unused variables must be prefixed with `_` (e.g., `_unusedParam`)
- **SvelteKit server files**: Common parameters like `request`, `event`, `cookies`, etc. can be unused

### Restricted Imports

- **Never import** from `*/dist/*` paths
- **Never import** `@chessarms/**/*.js` (use TypeScript imports)

### Code Style

- **Bracket spacing**: Use spaces inside object brackets: `{ foo: bar }`
- **No trailing commas** (Antfu default)
- **Semicolons**: Use when required by ASI rules (Antfu default)


### Safe Linting Rules

When performing safe linting operations:

- **Fix tab characters**: Replace with 2 spaces
- **Fix unused imports**: Add `_` prefix to variable names
- **DO NOT change log levels** (e.g., don't change `console.log` to `console.warn`)

## Exception: imported code
Projects might contains code taken from template libraries (like shadcn/ui).
Though imported code should be owned by me, I still prefer to keep it in original format.
Reason: once something gets reimported, I prefer to keep git diff minimal.
Otherwise, if we change it to our standards, after reimport it would be impossible to tell,
what changed in reimport, and what was our own modification.

Therefore, do not apply formating and linting rules to those sections, 
they would be speicified in project CLAUDE.md file.
