---
description: 'Validate that code changes follow Clean Architecture dependency rules'
---

# Validate Architecture

Review the following code changes and verify they respect Clean Architecture dependency rules:

**Rules:**

1. `Domain` must NOT reference `Application`, `Infrastructure`, or `Api`
2. `Application` must NOT reference `Infrastructure` or `Api`
3. `Infrastructure` must NOT reference `Api`
4. Repository interfaces belong in `Domain/Interfaces`, implementations in `Infrastructure/Repositories`
5. Use cases belong in `Application/UseCases`

For each file changed, answer:

- Which layer does it belong to?
- Does it import/reference any forbidden layer?
- Are there any dependency rule violations?

If violations are found, explain exactly what is wrong and provide a corrected version.

After reviewing, run the architecture tests to confirm:

```
dotnet test tests/ArchitectureTests --no-build --verbosity normal
```
