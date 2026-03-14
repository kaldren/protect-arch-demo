#!/usr/bin/env bash
# PreToolUse hook — blocks edits to protected project convention files
# Prevents the agent from modifying architecture docs, coding standards,
# hook configs, and skill definitions.

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only check file-editing tools
case "$TOOL" in
  editFiles|create_file|replace_string_in_file|multi_replace_string_in_file|write_to_file|insert_edit) ;;
  *)
    echo '{"continue": true}'
    exit 0
    ;;
esac

# Extract file path(s) from tool input
FILE_PATHS=$(echo "$INPUT" | jq -r '
  [
    .tool_input.filePath // empty,
    .tool_input.file_path // empty,
    (.tool_input.files // [] | .[]),
    (.tool_input.replacements // [] | .[].filePath // empty)
  ] | map(select(. != "")) | .[]
' 2>/dev/null)

# Protected path patterns
PROTECTED_PATTERNS=(
  "docs/ARCHITECTURE.md"
  "docs/CODE_CONVENTIONS.md"
  "docs/NAMING_CONVENTIONS.md"
  ".github/copilot-instructions.md"
  ".github/hooks/"
  ".github/skills/"
)

for FILE_PATH in $FILE_PATHS; do
  # Normalize: convert backslashes, strip absolute prefix
  NORMALIZED=$(echo "$FILE_PATH" | sed 's|\\|/|g' | sed 's|.*/protect-arch-demo/||')

  for PATTERN in "${PROTECTED_PATTERNS[@]}"; do
    # Check exact match or prefix match (for directory patterns ending in /)
    if [ "$NORMALIZED" = "$PATTERN" ] || [[ "$NORMALIZED" == "${PATTERN}"* ]]; then
      cat <<EOF
{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "PROTECTED FILE: '$NORMALIZED' is a project convention or configuration file that must not be modified by the agent. Edit it manually if changes are needed."
  }
}
EOF
      exit 0
    fi
  done
done

# Not a protected file — allow
echo '{"continue": true}'
exit 0
