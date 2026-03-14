```skill
---
name: architecture-rules
description: "Clean architecture layer definitions, dependency rules, and structural placement rules for the project. Use whenever validating, reviewing, or generating code that must respect layer boundaries."
---

# Architecture Rules

This skill provides the canonical architecture knowledge for the project. All agents must follow these rules — do not hardcode or restate them; always derive checks from the source docs.

## Source of Truth

Before performing any architecture-related task, read these files:

- `docs/ARCHITECTURE.md` — layer definitions, dependency table, structural rules.
- `docs/CODE_CONVENTIONS.md` — file/folder conventions, DI rules, use case conventions.
- `docs/NAMING_CONVENTIONS.md` — type naming patterns, namespace structure.

Treat these documents as the **sole source of truth**. If a rule is not in these docs, it does not apply.

## Layer Model (innermost → outermost)

```

src/
├── Domain/ # Entities & interfaces — depends on NOTHING
├── Application/ # Use cases — depends only on Domain
├── Infrastructure/ # Data access — depends on Domain + Application
└── Api/ # HTTP + DI — depends on Application + Infrastructure

```

## Key Constraints

- The dependency table in `docs/ARCHITECTURE.md` defines which layers may reference which. Any reference not explicitly allowed is **forbidden**.
- Repository **interfaces** belong in `Domain/Interfaces/`; **implementations** belong in `Infrastructure/Repositories/`.
- Use cases belong in `Application/UseCases/`.
- DI registration happens **exclusively** in `Api/Program.cs`.
- Architecture tests in `tests/ArchitectureTests/` enforce every forbidden dependency pair. New layers or projects require new tests.

## Inside-Out Build Order

When creating or modifying features, always work from the innermost layer outward:

1. **Domain** — entities, interfaces. No references to other layers.
2. **Application** — use cases. References Domain only.
3. **Infrastructure** — repository implementations. References Domain and Application.
4. **Api** — endpoints, DI. References Application and Infrastructure.

Never skip a layer or put logic in the wrong one.

```
