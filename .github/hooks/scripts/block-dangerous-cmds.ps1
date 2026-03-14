#!/usr/bin/env pwsh
# PreToolUse hook — blocks dangerous terminal commands
# Prevents destructive operations like force pushes, mass deletions,
# accidental package publishing, and destructive SQL.

$input_json = [Console]::In.ReadToEnd() | ConvertFrom-Json

$tool = $input_json.tool_name

# Only check terminal/command tools
if ($tool -notin @("run_in_terminal", "execute_command", "run_command")) {
    @{ continue = $true } | ConvertTo-Json
    exit 0
}

# Extract the command string
$command = ""
if ($input_json.tool_input.command) {
    $command = $input_json.tool_input.command
}

if (-not $command) {
    @{ continue = $true } | ConvertTo-Json
    exit 0
}

# Dangerous command patterns (case-insensitive)
$dangerousPatterns = @(
    # Destructive filesystem operations
    @{ Pattern = 'rm\s+(-[a-zA-Z]*f[a-zA-Z]*\s+)?(-[a-zA-Z]*r[a-zA-Z]*\s+)?(\/|~|\.\.)'; Reason = 'Recursive deletion of critical paths' }
    @{ Pattern = 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*\s+)?(-[a-zA-Z]*f[a-zA-Z]*\s+)?(\/|~|\.\.)'; Reason = 'Recursive deletion of critical paths' }
    @{ Pattern = 'del\s+/[sS]\s+/[qQ]'; Reason = 'Recursive silent deletion (Windows)' }
    @{ Pattern = 'format\s+[a-zA-Z]:'; Reason = 'Disk format command' }
    @{ Pattern = 'Remove-Item\s+.*-Recurse.*-Force'; Reason = 'Recursive forced deletion (PowerShell)' }

    # Destructive Git operations
    @{ Pattern = 'git\s+push\s+.*(-f|--force)\b'; Reason = 'Force push can destroy remote history' }
    @{ Pattern = 'git\s+clean\s+.*-fd'; Reason = 'Force clean removes untracked files and directories' }
    @{ Pattern = 'git\s+reset\s+--hard\s+.*origin'; Reason = 'Hard reset to remote can lose local work' }

    # Destructive SQL operations
    @{ Pattern = 'DROP\s+(TABLE|DATABASE|SCHEMA)\b'; Reason = 'Destructive SQL — drops database objects' }
    @{ Pattern = 'TRUNCATE\s+TABLE\b'; Reason = 'Destructive SQL — truncates table data' }

    # Accidental publishing
    @{ Pattern = 'dotnet\s+nuget\s+push\b'; Reason = 'Accidental NuGet package publishing' }
    @{ Pattern = 'npm\s+publish\b'; Reason = 'Accidental npm package publishing' }
)

foreach ($entry in $dangerousPatterns) {
    if ($command -imatch $entry.Pattern) {
        $output = @{
            continue           = $true
            hookSpecificOutput = @{
                hookEventName            = "PreToolUse"
                permissionDecision       = "deny"
                permissionDecisionReason = "DANGEROUS COMMAND BLOCKED: $($entry.Reason). Command: '$command'. Run this manually in the terminal if you really intend to."
            }
        }
        $output | ConvertTo-Json -Depth 3
        exit 0
    }
}

# Command is safe — allow
@{ continue = $true } | ConvertTo-Json
exit 0
