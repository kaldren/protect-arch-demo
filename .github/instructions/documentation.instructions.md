---
name: Documentation
description: XML doc comments, ADR format, README standards, and inline commenting guidelines.
applyTo: "**/*.cs,**/*.md"
---

# Documentation Guidelines

These rules govern code documentation, architecture decision records, and project-level docs.

## XML Doc Comments (C# Files)

- **Required** on all `public` and `protected` types and members.
- Include at minimum:
  - `<summary>` — one-sentence description of what the member does.
  - `<param name="...">` — for every parameter.
  - `<returns>` — for methods with non-void return types.
  - `<exception cref="...">` — for methods that throw documented exceptions.
- Example:
  ```csharp
  /// <summary>
  /// Retrieves a weather forecast by its unique identifier.
  /// </summary>
  /// <param name="id">The forecast identifier.</param>
  /// <returns>The matching forecast, or <c>null</c> if not found.</returns>
  /// <exception cref="ArgumentOutOfRangeException">Thrown when <paramref name="id"/> is negative.</exception>
  public WeatherForecast? GetById(int id)
  ```
- Do **not** add XML comments to `private` members unless the logic is non-obvious.
- Avoid restating the obvious — `/// Gets or sets the name.` on a `Name` property adds no value.

## Inline Comments

- Explain **why**, not **what** — the code should be self-explanatory for the *what*.
- Use `// TODO:` for planned work and `// HACK:` for known workarounds — these are searchable.
- Never leave commented-out code in committed files.

## Architecture Decision Records (ADRs)

- Store ADRs in `docs/adr/` with the naming pattern `NNNN-short-title.md` (e.g., `0004-use-fluentvalidation.md`).
- Write an ADR when:
  - Adding a new library or framework.
  - Changing an architectural pattern.
  - Choosing between non-trivial alternatives.
- ADR template:
  ```markdown
  # NNNN. Title
  
  **Status:** Proposed | Accepted | Deprecated | Superseded by [NNNN]
  
  ## Context
  What is the issue or decision to be made?
  
  ## Decision
  What was decided and why?
  
  ## Consequences
  What are the positive and negative outcomes?
  ```

## README & Project Docs

- [README.md](../../README.md) must include: project overview, prerequisites, getting started, architecture summary, and API reference.
- Keep the README in sync with the codebase — update it when adding features or changing setup steps.
- Use Markdown formatting consistently: headings for sections, code blocks for commands, tables for structured data.

## Api.http File

- Keep `src/Api/Api.http` updated with example requests for all endpoints.
- Include at least one request per endpoint with realistic sample data.
- Group requests by resource and annotate with `###` separators.
