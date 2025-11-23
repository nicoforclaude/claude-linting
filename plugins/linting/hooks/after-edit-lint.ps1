# Minimal TS/JS auto-lint hook (PowerShell version)
# Only runs on .ts/.tsx/.js/.jsx files, uses npx eslint directly
# Only applies layout fixes (cosmetic: spacing, semicolons, etc.)

$input_json = $input | Out-String
$data = $input_json | ConvertFrom-Json -ErrorAction SilentlyContinue

$filePath = $data.toolInput.file_path

Write-Output "[lint-hook] Starting..."
Write-Output "[lint-hook] File: $filePath"

if (-not $filePath) {
    Write-Output "[lint-hook] No file path, skipping"
    exit 0
}

# Only .ts/.tsx/.js/.jsx files that exist
if ($filePath -notmatch '\.(ts|tsx|js|jsx)$') {
    Write-Output "[lint-hook] Not a TS/JS file, skipping"
    exit 0
}
if (-not (Test-Path $filePath)) {
    Write-Output "[lint-hook] File does not exist, skipping"
    exit 0
}

Write-Output "[lint-hook] Running ESLint..."

# Run ESLint with LAYOUT fixes only (cosmetic: spacing, semicolons, etc.)
# No suggestions (import reordering, etc.), no problem fixes (logic changes)
try {
    $output = npx eslint $filePath --fix --fix-type layout --cache 2>&1
    Write-Output "[lint-hook] ESLint output: $output"
    Write-Output "[lint-hook] Done"
} catch {
    Write-Output "[lint-hook] Error: $_"
}
exit 0
