#requires -Version 5.1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$Owner = 'funnybunnyofdoom'
$Repo = 'Game-Maker-Sandbox'
$FullName = "$Owner/$Repo"
$ProjectTitle = 'Game Maker Sandbox'

function Require-Tool($Name, $InstallHint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "$Name not found. $InstallHint"
    }
}
function Check-Exit($Operation) {
    if ($LASTEXITCODE -ne 0) { throw "$Operation failed (exit code $LASTEXITCODE)." }
}

Require-Tool 'git' 'Install Git for Windows: winget install --id Git.Git -e'
Require-Tool 'gh' 'Install GitHub CLI: winget install --id GitHub.cli -e'
& gh auth status
Check-Exit 'GitHub authentication; run gh auth login first'

if (-not (Test-Path '.git')) {
    & git init -b main
    Check-Exit 'git init'
}
& git branch -M main
Check-Exit 'git branch'
& git add -- index.html README.md AGENTS.md .gitignore planning setup-github.ps1
Check-Exit 'git add'
$changes = & git status --porcelain
if ($changes) {
    & git commit -m 'Import Pixel Sandbox 0.2 as Game Maker Sandbox with initial roadmap'
    Check-Exit 'git commit; configure git user.name and user.email if necessary'
}

# Prefer the existing repo if this script is rerun.
& gh repo view $FullName --json name --jq '.name' 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating private GitHub repository $FullName..."
    & gh repo create $FullName --private --source . --remote origin --push --description 'Browser pixel sandbox and game-making toolkit'
    Check-Exit 'gh repo create'
} else {
    Write-Host "Repository $FullName already exists; pushing current main branch."
    & git remote get-url origin 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        & git remote add origin "https://github.com/$FullName.git"
        Check-Exit 'git remote add'
    }
    & git push -u origin main
    Check-Exit 'git push'
}

$Issues = @(
    @{ Title = 'Player Creator: create a player character from an existing NPC'; File = 'planning/issues/01-npc-to-player.md' },
    @{ Title = 'NPC and Player Creator: add a configurable Swim attribute'; File = 'planning/issues/02-swim-attribute.md' },
    @{ Title = 'NPC and Player Creators: hide/show mount point overlays'; File = 'planning/issues/03-mount-visibility.md' },
    @{ Title = 'All editors: consolidate toggleable attributes into one Attributes menu'; File = 'planning/issues/04-attributes-menu.md' }
)

$existing = @(& gh issue list --repo $FullName --state all --limit 200 --json title,url | ConvertFrom-Json)
Check-Exit 'gh issue list'
$IssueUrls = @()
foreach ($Issue in $Issues) {
    $found = $existing | Where-Object { $_.title -eq $Issue.Title } | Select-Object -First 1
    if ($found) {
        Write-Host "Already exists: $($found.title)"
        $IssueUrls += $found.url
        continue
    }
    $url = (& gh issue create --repo $FullName --title $Issue.Title --body-file $Issue.File)
    Check-Exit "create issue $($Issue.Title)"
    $url = ($url | Select-Object -Last 1).Trim()
    $IssueUrls += $url
    Write-Host "Created $url"
}

Write-Host "Repository: https://github.com/$FullName"
Write-Host "Issues: https://github.com/$FullName/issues"

# A GitHub Projects board is additional organization. Missing 'project' scope
# should not prevent the repository and issues above from being created.
Write-Host 'Checking GitHub Projects access...'
$plistRaw = & gh project list --owner $Owner --format json --limit 100 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Warning 'Could not access GitHub Projects. Run: gh auth refresh -s project, then rerun this script.'
    exit 0
}
$plist = $plistRaw | ConvertFrom-Json
$proj = @($plist.projects) | Where-Object { $_.title -eq $ProjectTitle } | Select-Object -First 1
if (-not $proj) {
    $projRaw = & gh project create --owner $Owner --title $ProjectTitle --format json
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Project board creation failed; issues and repository are ready.'; exit 0 }
    $proj = $projRaw | ConvertFrom-Json
    Write-Host "Created GitHub Project: $($proj.url)"
}
if (-not $proj.number) {
    Write-Warning 'Project number unavailable. Repository and issues are ready.'
    exit 0
}
& gh project link $proj.number --owner $Owner --repo $FullName
if ($LASTEXITCODE -ne 0) { Write-Warning 'Project link step failed; manually link the repository in GitHub Projects.' }
foreach ($url in $IssueUrls) {
    & gh project item-add $proj.number --owner $Owner --url $url | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Warning "Could not add $url to the project board." }
}
Write-Host "GitHub Project: https://github.com/users/$Owner/projects/$($proj.number)"
Write-Host 'Done.'
