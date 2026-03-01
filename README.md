# Winter is Coming... Protect Your Architecture 🏰

A demo project showing how to **enforce Clean Architecture** using AI — both locally with GitHub Copilot and in CI with the Copilot review agent.

## Architecture

```
src/
├── Domain/              # Entities & interfaces — depends on NOTHING
├── Application/         # Use cases — depends only on Domain
├── Infrastructure/      # Data access — depends on Domain + Application
└── Api/                 # HTTP + DI — depends on Application + Infrastructure

tests/
└── ArchitectureTests/   # NetArchTest — enforces dependency rules
```

## The Four Walls of Defense

This project demonstrates four GitHub Copilot customization features that act as concentric walls protecting your architecture:

### 🧱 Wall 1 — Custom Instructions (always-on guardrails)

**File:** `.github/copilot-instructions.md`

Automatically included in **every** Copilot interaction. Tells the AI about the layer rules, coding guidelines, and what's allowed where. The AI reads this before writing a single line of code.

**How to demo:** Just ask Copilot to add a feature — it will already know the architecture rules.

---

### 🧱 Wall 2 — Agent Skill (specialized knowledge, on-demand)

**File:** `.github/skills/clean-architecture-review/SKILL.md`

A portable, reusable skill that teaches Copilot how to review code for Clean Architecture violations. Loaded automatically when the task matches the skill description, or invoke it manually with `/clean-architecture-review` in chat.

Includes a helper script `run-arch-tests.ps1` that Copilot can execute.

**How to demo:** Type `/clean-architecture-review` in chat, or ask Copilot to "review my code for architecture violations" and it will pick up the skill automatically.

---

### 🧱 Wall 3 — Custom Agent (the Architecture Guardian)

**File:** `.github/agents/arch-guardian.agent.md`

A custom agent persona that acts as an architecture sentry. Switch to it from the agents dropdown in chat. It will:

- Identify which layer each file belongs to
- Scan `using` statements for forbidden dependencies
- Run the architecture tests
- Report violations with exact fixes

**How to demo:** Select **arch-guardian** from the agents dropdown and ask it to "review the codebase" or "check if this change is safe."

---

### 🧱 Wall 4 — Hooks (automated enforcement)

**File:** `.github/hooks/arch-guard.json`  
**Scripts:** `.github/hooks/scripts/arch-test.ps1` / `arch-test.sh`

A `PostToolUse` hook that runs architecture tests **automatically** after Copilot edits any file. If the tests fail, the violation is reported back to the agent as context, and it will attempt to fix it.

**How to demo:** Ask Copilot in agent mode to make a change that violates the architecture (e.g., "add a `using Infrastructure` statement in Domain"). The hook will catch it and feed the failure back.

---

## Quick Start

```bash
# Build
dotnet build

# Run architecture tests
dotnet test tests/ArchitectureTests

# Run the API
dotnet run --project src/Api
```

## Try Breaking It

To see the defenses in action, try asking Copilot to:

1. **"Add a direct database call in the Domain layer"** — the custom instructions will resist, the hook will catch it, and the tests will fail.
2. **"Import Infrastructure in Application"** — same multi-layer defense kicks in.
3. **"Put a repository implementation in Domain"** — the skill and agent will flag the structural violation.

## Architecture Test Coverage

| Test                                                | What it verifies         |
| --------------------------------------------------- | ------------------------ |
| `Domain_Should_Not_Depend_On_Application`           | Domain isolation         |
| `Domain_Should_Not_Depend_On_Infrastructure`        | Domain isolation         |
| `Domain_Should_Not_Depend_On_Api`                   | Domain isolation         |
| `Application_Should_Not_Depend_On_Infrastructure`   | Application isolation    |
| `Application_Should_Not_Depend_On_Api`              | Application isolation    |
| `Infrastructure_Should_Not_Depend_On_Api`           | Infrastructure isolation |
| `Domain_Interfaces_Should_Not_Have_Implementations` | Structural rule          |

## The Four Features Demonstrated

| Feature                 | File                                                | Purpose                                                                                         |
| ----------------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Custom Instructions** | `.github/copilot-instructions.md`                   | Always-on guardrails — tells Copilot the architecture rules on every interaction                |
| **Agent Skill**         | `.github/skills/clean-architecture-review/SKILL.md` | Portable, on-demand skill for reviewing architecture violations (`/clean-architecture-review`)  |
| **Custom Agent**        | `.github/agents/arch-guardian.agent.md`             | "Architecture Guardian" persona — select from agents dropdown for a specialized reviewer        |
| **Hooks**               | `.github/hooks/arch-guard.json`                     | `PostToolUse` hook that auto-runs `dotnet test` after every file edit and feeds violations back |
