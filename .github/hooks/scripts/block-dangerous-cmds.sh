#!/usr/bin/env bash
# PreToolUse hook — blocks dangerous terminal commands
# Prevents destructive operations like force pushes, mass deletions,
# accidental package publishing, and destructive SQL.

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only check terminal/command tools
case "$TOOL" in
  run_in_terminal|execute_command|run_command) ;;
  *)
    echo '{"continue": true}'
    exit 0
    ;;
esac

# Extract the command string
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  echo '{"continue": true}'
  exit 0
fi

# Check against dangerous patterns (case-insensitive)
check_pattern() {
  local pattern="$1"
  local reason="$2"
  if echo "$COMMAND" | grep -iqE "$pattern"; then
    cat <<EOF
{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "DANGEROUS COMMAND BLOCKED: ${reason}. Run this manually in the terminal if you really intend to."
  }
}
EOF
    exit 0
  fi
}

# Destructive filesystem operations
check_pattern 'rm\s+(-[a-zA-Z]*[rf][a-zA-Z]*\s+){1,2}(\/|~|\.\.)' 'Recursive deletion of critical paths'
check_pattern 'del\s+/[sS]\s+/[qQ]' 'Recursive silent deletion (Windows)'
check_pattern 'format\s+[a-zA-Z]:' 'Disk format command'
check_pattern 'Remove-Item\s+.*-Recurse.*-Force' 'Recursive forced deletion (PowerShell)'

# Destructive Git operations
check_pattern 'git\s+push\s+.*(-f|--force)\b' 'Force push can destroy remote history'
check_pattern 'git\s+clean\s+.*-fd' 'Force clean removes untracked files and directories'
check_pattern 'git\s+reset\s+--hard\s+.*origin' 'Hard reset to remote can lose local work'

# Destructive SQL operations
check_pattern 'DROP\s+(TABLE|DATABASE|SCHEMA)\b' 'Destructive SQL — drops database objects'
check_pattern 'TRUNCATE\s+TABLE\b' 'Destructive SQL — truncates table data'

# Accidental publishing
check_pattern 'dotnet\s+nuget\s+push\b' 'Accidental NuGet package publishing'
check_pattern 'npm\s+publish\b' 'Accidental npm package publishing'

# Command is safe — allow
echo '{"continue": true}'
exit 0
