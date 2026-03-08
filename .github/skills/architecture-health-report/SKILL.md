---
name: architecture-health-report
description: 'Generates a full architecture health report — dependency rules, code-level boundaries, naming conventions, and test coverage gaps. Use when you want a comprehensive audit of the solution.'
---

# Architecture Health Report

Generate a comprehensive health report for this solution. The architecture rules are defined in the project's custom instructions — use them as the source of truth. The naming conventions are defined in `docs/NAMING_CONVENTIONS.md`.

Do NOT repeat or hardcode any rules. Read them from their source, then validate the codebase against them.

## Steps

### 1. Dependency Rule Violations

- Open every `.csproj` under `src/` and check `<ProjectReference>` entries against the dependency rules from the custom instructions.
- Flag any forbidden reference.

### 2. Code-Level Violations

- Scan `using` directives in `.cs` files under `src/` for namespace references that cross layer boundaries as defined in the custom instructions.

### 3. Naming Convention Check

- Read `docs/NAMING_CONVENTIONS.md` and verify the codebase follows the patterns defined there (use case suffixes, interface prefixes, file-to-type name matching, etc.).

### 4. Architecture Test Coverage

- Read the dependency rules table from the custom instructions.
- Check that `tests/ArchitectureTests/` has at least one test covering each forbidden dependency pair.
- Flag any rule that has no corresponding test.

## Output Format

```markdown
# 🏥 Architecture Health Report

## Dependency Rules: ✅ PASS | ❌ FAIL

<!-- list violations or "No violations found" -->

## Code-Level Boundaries: ✅ PASS | ❌ FAIL

<!-- list using-directive violations or "No violations found" -->

## Naming Conventions: ✅ PASS | ❌ FAIL

<!-- list mismatches or "All names follow conventions" -->

## Test Coverage: ✅ PASS | ⚠️ GAPS

<!-- list missing test cases or "All rules covered" -->
```
