#!/usr/bin/env pwsh
# PreToolUse hook — blocks edits to protected project convention files
# Prevents the agent from modifying architecture docs, coding standards,
# hook configs, and skill definitions.

$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json

$tool = $input_json.tool_name

# Only check file-editing tools
if ($tool -notin @("editFiles", "create_file", "replace_string_in_file", "multi_replace_string_in_file", "write_to_file", "insert_edit")) {
    @{ continue = $true } | ConvertTo-Json
    exit 0
}

# Extract file path(s) from tool input
$filePaths = @()

if ($input_json.tool_input.filePath) {
    $filePaths += $input_json.tool_input.filePath
}
if ($input_json.tool_input.file_path) {
    $filePaths += $input_json.tool_input.file_path
}
if ($input_json.tool_input.files) {
    $filePaths += $input_json.tool_input.files
}
if ($input_json.tool_input.replacements) {
    foreach ($r in $input_json.tool_input.replacements) {
        if ($r.filePath) { $filePaths += $r.filePath }
    }
}

# Normalize paths to forward slashes and make relative
$normalizedPaths = $filePaths | ForEach-Object {
    $p = $_ -replace '\\', '/'
    # Strip absolute prefix to get workspace-relative path
    if ($p -match '(?i).*/protect-arch-demo/(.*)$') {
        $matches[1]
    }
    else {
        $p
    }
}

# Protected path patterns (workspace-relative, matched as prefixes or exact)
$protectedPatterns = @(
    'docs/ARCHITECTURE.md',
    'docs/CODE_CONVENTIONS.md',
    'docs/NAMING_CONVENTIONS.md',
    '.github/copilot-instructions.md',
    '.github/hooks/',
    '.github/skills/'
)

foreach ($filePath in $normalizedPaths) {
    foreach ($pattern in $protectedPatterns) {
        if ($filePath -eq $pattern -or $filePath.StartsWith($pattern)) {
            $output = @{
                continue           = $true
                hookSpecificOutput = @{
                    hookEventName            = "PreToolUse"
                    permissionDecision       = "deny"
                    permissionDecisionReason = "PROTECTED FILE: '$filePath' is a project convention or configuration file that must not be modified by the agent. Edit it manually if changes are needed."
                }
            }
            $output | ConvertTo-Json -Depth 3
            exit 0
        }
    }
}

# Not a protected file — allow
@{ continue = $true } | ConvertTo-Json
exit 0
