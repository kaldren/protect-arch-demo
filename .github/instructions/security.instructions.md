---
name: Security
description: OWASP-aligned security guardrails for .NET — input validation, secrets management, injection prevention, auth patterns.
applyTo: "src/**/*.cs"
---

# Security Guidelines

These rules complement the brief security section in the `coding-standards` skill. Apply them to all production code.

## Injection Prevention

- **Never** concatenate user input into SQL, OData, or command strings.
- Use parameterised queries, EF Core LINQ, or Dapper parameters for all data access.
- Sanitise any input used in file paths, URLs, or shell commands.

## Input Validation

- Validate **all** inputs at the API boundary — use Data Annotations (`[Required]`, `[Range]`, `[StringLength]`) or FluentValidation.
- Reject requests that fail validation with `400 Bad Request` and a `ProblemDetails` body.
- Apply validation to route parameters, query strings, and request bodies.
- Never trust client-side validation alone.

## Secrets Management

- **Never** hardcode secrets, connection strings, API keys, or tokens in source code.
- Use `IConfiguration` with environment variables, User Secrets (development), or Azure Key Vault (production).
- If a secret appears in a commit, treat it as compromised and rotate immediately.
- Do not log secrets, tokens, or PII — use structured logging with redaction.

## Authentication & Authorization

- Use ASP.NET Core Identity, JWT Bearer tokens, or Microsoft Entra ID for authentication.
- Apply `[Authorize]` or `RequireAuthorization()` on endpoints that need protection.
- Prefer policy-based authorization over role checks where possible.
- Never implement custom cryptography — use `System.Security.Cryptography` or well-known libraries.

## HTTP Security Headers & CORS

- Enable HSTS (`UseHsts()`) and HTTPS redirection in production.
- Configure CORS explicitly — never use `AllowAnyOrigin()` with `AllowCredentials()`.
- Consider adding Content-Security-Policy, X-Content-Type-Options, and X-Frame-Options headers via middleware.

## Dependency Security

- Keep NuGet packages updated — run `dotnet list package --vulnerable` periodically.
- Pin package versions in `.csproj` files to avoid unexpected upgrades.
- Review transitive dependencies for known CVEs.

## Data Protection

- Use the ASP.NET Core Data Protection API for encrypting cookies and tokens.
- Hash passwords with `PasswordHasher<T>` — never store plaintext passwords.
- Apply the principle of least privilege to database and service accounts.
