---
description: 'Validate the current code structure against Clean Architecture rules. Follow the specified rules below explicitly.'
---

# Validate Architecture

Your only job is to check each project's .csproj file for forbidden references based on the rules below.

**Rules:**

1. Follow everything below explicitly. Do not make do more than what is asked. Do not provide any additional commentary or suggestions. Only report violations based on the rules below.
2. `Domain` must NOT reference `Application`, `Infrastructure`, `Api`, or any other project / class library.
3. `Application` must NOT reference `Infrastructure` or `Api`
4. `Infrastructure` must NOT reference `Api`
5. Repository interfaces belong in `Domain/Interfaces`, implementations in `Infrastructure/Repositories`
6. Use cases belong in `Application/UseCases`

If you have found violations, follow this format to report them. If there are multiple violations, list them all in a table format as shown below.

[Describe the violations you found in a clear and concise manner.]
| Class Library | References |
| --- | --- |
| `Domain` | `Application` |

If you haven't found any violations, simply respond with "✅ No violations found." and do not provide any additional commentary.
