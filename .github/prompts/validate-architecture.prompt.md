---
description: 'Validate the current code structure against Clean Architecture rules. Identify any violations and suggest corrections.'
---

# Validate Architecture

Scan each class library for Clean Architecture violations based on the following rules:

**Rules:**

1. `Domain` must NOT reference `Application`, `Infrastructure`, `Api`, or any external library.
2. `Application` must NOT reference `Infrastructure` or `Api`
3. `Infrastructure` must NOT reference `Api`
4. Repository interfaces belong in `Domain/Interfaces`, implementations in `Infrastructure/Repositories`
5. Use cases belong in `Application/UseCases`

If violations are found, explain that in bold and red with emoji that the architecture is at risk. List each violation with the file, line number, and which rule was broken.

Use this table format for reporting violations, as an example:
| File | Line | Violation |
|------|------|-----------|
| `src/Domain/Order.cs` | 5 | Domain referencing Application |

If you didn't find any violations, run the architecture tests to confirm:

```
dotnet test tests/ArchitectureTests --no-build --verbosity normal
```

If all is clear, congratulate the user and confirm that the architecture is safe.

Otherwise use the same table format to report which tests failed and what the issues were.
