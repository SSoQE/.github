[CmdletBinding()]
param(
    [string] $Organization = "SSoQE",
    [switch] $IncludeArchived
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$json = & gh repo list $Organization `
    --limit 500 `
    --json name,isArchived,isPrivate,defaultBranchRef,url,sshUrl

if ($LASTEXITCODE -ne 0) {
    throw "GitHub repository discovery failed for $Organization"
}

$repositories = $json | ConvertFrom-Json
if (-not $IncludeArchived) {
    $repositories = @($repositories | Where-Object { -not $_.isArchived })
}

$repositories |
    Sort-Object name |
    Select-Object name, isPrivate, isArchived, defaultBranchRef, url, sshUrl
