#!/usr/bin/env bash
# PostToolUse hook — runs architecture tests after Copilot edits files
# Only triggers when the tool is "editFiles" (i.e. Copilot wrote code)

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only run after file-editing tools
case "$TOOL" in
  editFiles|create_file|replace_string_in_file|write_to_file|insert_edit) ;;
  *)
    echo '{"continue": true}'
    exit 0
    ;;
esac

# Run architecture tests
if TEST_OUTPUT=$(dotnet test tests/ArchitectureTests --no-restore --verbosity quiet 2>&1); then
  echo '{"continue": true}'
  exit 0
else
  cat <<EOF
{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "ARCHITECTURE VIOLATION DETECTED! The architecture tests failed after your edit. Please review and fix the dependency rule violation. Test output: $(echo "$TEST_OUTPUT" | tr '\n' ' ')"
  }
}
EOF
  exit 0
fi
