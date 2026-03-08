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

### 3. Agent Skill (deep audit)

**File:** `.github/skills/architecture-health-report/SKILL.md`

A portable skill that generates a full architecture health report — dependency rules, code-level `using` boundaries, naming conventions, and test coverage gaps. It reads all rules from their source files (custom instructions + conventions docs) so nothing is duplicated.

> **Trigger:** Picked up automatically when you ask Copilot for an "architecture health report", or invoke explicitly:
>
> ```
> /architecture-health-report
> ```

---

### 4. Custom Agent (Architecture Guardian)

**File:** `.github/agents/arch-guardian.agent.md`

A custom agent persona with access to the codebase. It reviews files, checks dependencies, runs tests, and reports violations with fixes.

> **Trigger:** Select **arch-guardian** from the agents dropdown in Copilot Chat, then ask:
>
> ```
> Review the codebase for architecture violations
> ```

---

### 5. Hook (automated enforcement)

**File:** `.github/hooks/arch-guard.json`
**Scripts:** `.github/hooks/scripts/arch-test.ps1` / `arch-test.sh`

A `PostToolUse` hook that runs `dotnet test tests/ArchitectureTests` automatically after Copilot edits any file. If tests fail, the violation is fed back to the agent as context so it can self-correct.

> **Trigger:** Automatic — just use Copilot in agent mode to edit files. The hook fires after every edit.

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
