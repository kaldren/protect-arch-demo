#!/usr/bin/env pwsh
# Runs architecture tests and outputs a summary
param([switch]$Verbose)

$verbosity = if ($Verbose) { "normal" } else { "quiet" }

Write-Host "Running Clean Architecture tests..." -ForegroundColor Cyan
$output = dotnet test tests/ArchitectureTests --verbosity $verbosity 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "PASS - No architecture violations found" -ForegroundColor Green
}
else {
    Write-Host "FAIL - Architecture violations detected!" -ForegroundColor Red
    Write-Host $output
}

exit $LASTEXITCODE
