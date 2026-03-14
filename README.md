# Protect Your Architecture 🏰

A demo project showing how to **enforce Clean Architecture** with automated tests and AI guardrails using GitHub Copilot.

## Architecture

```
src/
├── Domain/              # Entities & interfaces — depends on NOTHING
├── Application/         # Use cases — depends only on Domain
├── Infrastructure/      # Data access — depends on Domain + Application
├── Api/                 # HTTP + DI — depends on Application + Infrastructure
└── ExternalService/     # ⚠️ External library — no layer should reference it

tests/
└── ArchitectureTests/   # ArchUnitNET — enforces dependency rules
```

### Dependency Rules

| Layer          | May reference               | Must NEVER reference             |
| -------------- | --------------------------- | -------------------------------- |
| Domain         | (nothing)                   | Application, Infrastructure, Api |
| Application    | Domain                      | Infrastructure, Api              |
| Infrastructure | Domain, Application         | Api                              |
| Api            | Application, Infrastructure | —                                |

---

## Architecture Guardrails

This project uses five GitHub Copilot customization features to protect the architecture. Here's what each one does and how to trigger it.

### 1. Custom Instructions (always-on)

**File:** `.github/copilot-instructions.md`

Automatically loaded into **every** Copilot interaction — chat, inline, agent mode. The AI knows the architecture rules before writing any code.

> **Trigger:** Nothing to do — it's always active. Just use Copilot normally.

---

### 2. Prompt File (on-demand validation)

**File:** `.github/prompts/validate-architecture.prompt.md`

A reusable prompt that scans all `.csproj` files for forbidden `<ProjectReference>` entries and reports violations in a table.

> **Trigger:** Open the prompt from the **Prompts** dropdown (📎) in Copilot Chat, or type:
>
> ```
> /validate-architecture
> ```

---

### 3. Agent Skills (reusable knowledge modules)

**Folder:** `.github/skills/`

Portable skills that inject domain-specific knowledge into Copilot and agents. Each skill encapsulates a set of rules so nothing is duplicated across agents.

| Skill                | File                                         | Purpose                                                                                            |
| -------------------- | -------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `backend-developer`  | `.github/skills/backend-developer/SKILL.md`  | Guides feature building with the inside-out workflow (Domain → Application → Infrastructure → Api) |
| `architecture-rules` | `.github/skills/architecture-rules/SKILL.md` | Layer definitions, dependency rules, and structural placement rules                                |
| `coding-standards`   | `.github/skills/coding-standards/SKILL.md`   | Code quality, naming, async, and security rules                                                    |
| `testing-patterns`   | `.github/skills/testing-patterns/SKILL.md`   | Test conventions, naming, framework setup, and ArchUnitNET patterns                                |

> **Trigger:** Skills are picked up automatically by agents that reference them. You can also invoke the backend-developer skill explicitly:
>
> ```
> /backend-developer
> ```

---

### 4. Custom Agents (multi-agent workflow)

**Folder:** `.github/agents/`

Six specialised agents that can be used independently or orchestrated together for full feature lifecycles.

| Agent            | File                     | Role                                                                                                              |
| ---------------- | ------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| `@architect`     | `architect.agent.md`     | **Read-only** scanner — produces architecture health reports in table format. Never modifies files.               |
| `@backend`       | `backend.agent.md`       | **Orchestrator** — coordinates the full feature lifecycle by delegating to Draft → Review → Test → Documentation. |
| `@draft`         | `draft.agent.md`         | Generates initial code following clean architecture and the inside-out build order.                               |
| `@review`        | `review.agent.md`        | Reviews code for quality, security, and architecture compliance. Never modifies files — only reports findings.    |
| `@test`          | `test.agent.md`          | Creates comprehensive test suites (unit, integration, architecture) and ensures all tests pass.                   |
| `@documentation` | `documentation.agent.md` | Generates and updates project documentation — README, API docs, ADRs, and inline doc comments.                    |

> **Trigger:** Select an agent from the agents dropdown in Copilot Chat. Examples:
>
> ```
> @architect Scan the codebase for architecture violations
> @backend Add a Product entity with CRUD endpoints
> ```

---

### 5. Hooks (automated safety guards)

**File:** `.github/hooks/safety-guards.json`
**Scripts:** `.github/hooks/scripts/`

Two `PreToolUse` hooks that intercept Copilot actions **before** they execute, preventing dangerous operations.

| Hook                         | Scripts                                                | What it does                                                                                                                                                                                           |
| ---------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Protect Files**            | `protect-files.ps1` / `protect-files.sh`               | Blocks edits to protected convention files (`docs/ARCHITECTURE.md`, `docs/CODE_CONVENTIONS.md`, `docs/NAMING_CONVENTIONS.md`, `.github/copilot-instructions.md`, `.github/hooks/`, `.github/skills/`). |
| **Block Dangerous Commands** | `block-dangerous-cmds.ps1` / `block-dangerous-cmds.sh` | Blocks destructive terminal commands — recursive deletions, force pushes, `DROP TABLE`, accidental `npm publish` / `dotnet nuget push`, and more.                                                      |

> **Trigger:** Automatic — fires before every file edit or terminal command in agent mode. Blocked actions return a denial reason to the agent.

---

## Quick Start

```bash
dotnet build
dotnet test tests/ArchitectureTests
dotnet run --project src/Api
```

## Try Breaking It

Ask Copilot in agent mode to:

1. **"Add a direct database call in the Domain layer"** — instructions resist, hook catches it, tests fail.
2. **"Import Infrastructure in Application"** — same multi-layer defense kicks in.
3. **"Put a repository implementation in Domain"** — skill and agent flag the structural violation.
4. **"Add a ProjectReference to ExternalService in Domain.csproj"** — tests catch the forbidden dependency.

## Docs

| Document                                                                         | Purpose                                                |
| -------------------------------------------------------------------------------- | ------------------------------------------------------ |
| [Code Conventions](docs/CODE_CONVENTIONS.md)                                     | Coding standards (C# style, DI, async, error handling) |
| [Naming Conventions](docs/NAMING_CONVENTIONS.md)                                 | Type/file/namespace naming rules per layer             |
| [ADR-0001: Clean Architecture](docs/adr/0001-use-clean-architecture.md)          | Why Clean Architecture was chosen                      |
| [ADR-0002: ArchUnitNET](docs/adr/0002-use-archunitnet-for-architecture-tests.md) | Why ArchUnitNET for architecture tests                 |
| [ADR-0003: Minimal APIs](docs/adr/0003-use-minimal-apis.md)                      | Why Minimal APIs over Controllers                      |
| [Contributing](CONTRIBUTING.md)                                                  | Branch workflow, commit conventions, PR process        |
