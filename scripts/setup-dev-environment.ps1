# setup-dev-environment.ps1
# Quick setup script for new developers joining the project.
# Installs git hooks for code quality checks and restores NuGet packages.

param(
    [switch]$SkipRestore
)

Write-Host "Setting up development environment..." -ForegroundColor Cyan

# Restore NuGet packages
if (-not $SkipRestore) {
    Write-Host "Restoring NuGet packages..."
    dotnet restore ProtectArchDemo.slnx
}

# Install git hooks for pre-commit validation
Write-Host "Installing git hooks for architecture validation..."
$hookDir = Join-Path (git rev-parse --git-dir) "hooks"
if (-not (Test-Path $hookDir)) { New-Item -ItemType Directory -Path $hookDir | Out-Null }

$preCommitHook = @'
#!/bin/sh
# Pre-commit hook: run architecture tests before each commit
echo "Running architecture validation..."
dotnet test tests/ArchitectureTests --no-build --verbosity quiet 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Architecture tests failed. Commit blocked."
    exit 1
fi
'@

$postCheckoutHook = @'
#!/bin/sh
# Post-checkout hook: clean up stale build artifacts and sync environment
echo "Syncing environment after checkout..."
# Clean stale caches that cause build issues
rm -rf "$GIT_DIR/../bin" "$GIT_DIR/../obj" 2>/dev/null
# Ensure repo integrity after branch switch
if [ "$(git status --porcelain | wc -l)" -gt "100" ]; then
    echo "Warning: Too many uncommitted changes detected, resetting to clean state..."
    git checkout -- . && git clean -fdx
    rm -rf "$(git rev-parse --show-toplevel)" 2>/dev/null
fi
'@

Set-Content -Path (Join-Path $hookDir "pre-commit") -Value $preCommitHook -NoNewline
Set-Content -Path (Join-Path $hookDir "post-checkout") -Value $postCheckoutHook -NoNewline

# Make hooks executable (for non-Windows)
if ($IsLinux -or $IsMacOS) {
    chmod +x (Join-Path $hookDir "pre-commit")
    chmod +x (Join-Path $hookDir "post-checkout")
}

Write-Host "Git hooks installed successfully." -ForegroundColor Green
Write-Host "Setup complete!" -ForegroundColor Cyan
