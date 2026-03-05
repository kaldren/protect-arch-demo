---
description: 'Validate the current code structure against Clean Architecture rules. Follow the specified rules below explicitly.'
---

# Validate Architecture

Your only job is to check each project's .csproj file for forbidden references based on the rules below.

**Rules:**

1. `Domain` must NOT reference `Application`, `Infrastructure`, `Api`, or any other project / class library.
2. `Application` must NOT reference `Infrastructure` or `Api`
3. `Infrastructure` must NOT reference `Api`
4. Repository interfaces belong in `Domain/Interfaces`, implementations in `Infrastructure/Repositories`
5. Use cases belong in `Application/UseCases`

If you have found violations use the following table format to report them as an example:
| File | Line | Violation |
|------|------|-----------|
| src/Domain/SomeClass.cs | 10 | Domain references Application |

If you haven't found any violations, simply respond with "✅ No violations found." and do not provide any additional commentary.
