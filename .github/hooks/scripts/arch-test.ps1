#!/usr/bin/env pwsh
# PostToolUse hook — runs architecture tests after Copilot edits files
# Only triggers when the tool is "editFiles" (i.e. Copilot wrote code)

$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json

$tool = $input_json.tool_name

# Only run after file-editing tools
if ($tool -notin @("editFiles", "create_file", "replace_string_in_file", "multi_replace_string_in_file", "write_to_file", "insert_edit")) {
    # Not a file edit — skip silently
    @{ continue = $true } | ConvertTo-Json
    exit 0
}

# Run architecture tests
$testResult = dotnet test tests/ArchitectureTests --no-restore --verbosity quiet 2>&1

if ($LASTEXITCODE -ne 0) {
    $output = @{
        continue           = $true
        hookSpecificOutput = @{
            hookEventName     = "PostToolUse"
            additionalContext = "ARCHITECTURE VIOLATION DETECTED! The architecture tests failed after your edit. Please review and fix the dependency rule violation. Test output: $($testResult -join "`n")"
        }
    }
    $output | ConvertTo-Json -Depth 3
    exit 0
}

# Tests passed — confirm continue
@{ continue = $true } | ConvertTo-Json
exit 0
