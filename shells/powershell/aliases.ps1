# =============================================================================
# Shell Aliases — PowerShell
# Dot-source from $PROFILE:  . ~/dotfiles/shells/powershell/aliases.ps1
#
# Conventions:
#   - Every alias is backed by a named function (Invoke-<Verb><Noun>).
#   - Each function prints the resolved command in Cyan before running it.
#   - Set-Alias wires the short name to the verbose function.
#   - OS aliases are omitted (bash/fish only per spec).
#   - `ga.` is named `gaa` here — trailing dot conflicts with PS member access.
# =============================================================================

# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

function global:Test-CommandExists([string]$Command) {
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Detect the Node/JS package manager.
# Priority: .jmanager file (walked up from $PWD) → lock files → npm default.
function global:Get-NodePackageManager {
    $dir = $PWD.Path
    while ($dir -ne [System.IO.Path]::GetPathRoot($dir)) {
        $jmanager = Join-Path $dir '.jmanager'
        if (Test-Path $jmanager) {
            return (Get-Content $jmanager -Raw).Trim()
        }
        $dir = Split-Path $dir -Parent
    }
    if (Test-Path 'bun.lockb')       { return 'bun'  }
    if (Test-Path 'bun.lock')        { return 'bun'  }
    if (Test-Path 'pnpm-lock.yaml')  { return 'pnpm' }
    if (Test-Path 'yarn.lock')       { return 'yarn' }
    if (Test-Path 'package-lock.json') { return 'npm' }
    return 'npm'
}

# ---------------------------------------------------------------------------
# cd / zoxide
# zoxide provides `z` and `zi` when initialised via:
#   Invoke-Expression (& zoxide init powershell | Out-String)
# GoUp / GoUpTwo wrap those commands with a fallback to Set-Location.
# ---------------------------------------------------------------------------

function global:Invoke-GoUp {
    if (Test-CommandExists 'zoxide') {
        Write-Host '→ z ..' -ForegroundColor Cyan
        z ..
    } else {
        Write-Host '→ Set-Location ..' -ForegroundColor Cyan
        Set-Location ..
    }
}
Set-Alias -Name '..' -Value Invoke-GoUp -Scope Global -Force

function global:Invoke-GoUpTwo {
    if (Test-CommandExists 'zoxide') {
        Write-Host '→ z ../..' -ForegroundColor Cyan
        z ../..
    } else {
        Write-Host '→ Set-Location ../..' -ForegroundColor Cyan
        Set-Location ../..
    }
}
Set-Alias -Name '...' -Value Invoke-GoUpTwo -Scope Global -Force

# Zoxide extras (only useful when zoxide is installed)
function global:Invoke-ZoxideList {
    if (-not (Test-CommandExists 'zoxide')) { Write-Warning 'zoxide is not installed'; return }
    Write-Host "→ zoxide query --list $args" -ForegroundColor Cyan
    zoxide query --list @args
}
Set-Alias -Name 'zl' -Value Invoke-ZoxideList -Scope Global -Force

function global:Invoke-ZoxideAdd {
    if (-not (Test-CommandExists 'zoxide')) { Write-Warning 'zoxide is not installed'; return }
    Write-Host "→ zoxide add $args" -ForegroundColor Cyan
    zoxide add @args
}
Set-Alias -Name 'za' -Value Invoke-ZoxideAdd -Scope Global -Force

function global:Invoke-ZoxideRemove {
    if (-not (Test-CommandExists 'zoxide')) { Write-Warning 'zoxide is not installed'; return }
    Write-Host "→ zoxide remove $args" -ForegroundColor Cyan
    zoxide remove @args
}
Set-Alias -Name 'zr' -Value Invoke-ZoxideRemove -Scope Global -Force

function global:Invoke-ZoxideQuery {
    if (-not (Test-CommandExists 'zoxide')) { Write-Warning 'zoxide is not installed'; return }
    Write-Host "→ zoxide query $args" -ForegroundColor Cyan
    zoxide query @args
}
Set-Alias -Name 'zq' -Value Invoke-ZoxideQuery -Scope Global -Force

# ---------------------------------------------------------------------------
# ls / eza
# eza is used when available; Get-ChildItem is the fallback.
# Advanced aliases (lt, lg, ll-tree, ld) require eza.
# ---------------------------------------------------------------------------

function global:Invoke-List {
    if (Test-CommandExists 'eza') {
        Write-Host "→ eza --icons=auto $args" -ForegroundColor Cyan
        eza --icons=auto @args
    } else {
        Get-ChildItem @args
    }
}
Set-Alias -Name 'l' -Value Invoke-List -Scope Global -Force

function global:Invoke-ListAll {
    if (Test-CommandExists 'eza') {
        Write-Host "→ eza --icons=auto -a $args" -ForegroundColor Cyan
        eza --icons=auto -a @args
    } else {
        Get-ChildItem -Force @args
    }
}
Set-Alias -Name 'la' -Value Invoke-ListAll -Scope Global -Force

function global:Invoke-ListLong {
    if (Test-CommandExists 'eza') {
        Write-Host "→ eza --icons=auto -lh $args" -ForegroundColor Cyan
        eza --icons=auto -lh @args
    } else {
        Get-ChildItem @args | Format-List
    }
}
Set-Alias -Name 'll' -Value Invoke-ListLong -Scope Global -Force

function global:Invoke-ListLongAll {
    if (Test-CommandExists 'eza') {
        Write-Host "→ eza --icons=auto -lha $args" -ForegroundColor Cyan
        eza --icons=auto -lha @args
    } else {
        Get-ChildItem -Force @args | Format-List
    }
}
Set-Alias -Name 'lla' -Value Invoke-ListLongAll -Scope Global -Force

function global:Invoke-ListTree {
    if (-not (Test-CommandExists 'eza')) {
        Write-Warning 'eza is not installed (required for tree view)'; return
    }
    Write-Host "→ eza --icons=auto --tree $args" -ForegroundColor Cyan
    eza --icons=auto --tree @args
}
Set-Alias -Name 'lt' -Value Invoke-ListTree -Scope Global -Force

function global:Invoke-ListGit {
    if (-not (Test-CommandExists 'eza')) {
        Write-Warning 'eza is not installed (required for git status view)'; return
    }
    Write-Host "→ eza --icons=auto -lh --git $args" -ForegroundColor Cyan
    eza --icons=auto -lh --git @args
}
Set-Alias -Name 'lg' -Value Invoke-ListGit -Scope Global -Force

function global:Invoke-ListLongTree {
    if (-not (Test-CommandExists 'eza')) {
        Write-Warning 'eza is not installed (required for tree view)'; return
    }
    Write-Host "→ eza --icons=auto --tree -lh $args" -ForegroundColor Cyan
    eza --icons=auto --tree -lh @args
}
Set-Alias -Name 'll-tree' -Value Invoke-ListLongTree -Scope Global -Force

function global:Invoke-ListDirs {
    if (-not (Test-CommandExists 'eza')) {
        Write-Warning 'eza is not installed (required for directory-only view)'; return
    }
    Write-Host "→ eza --icons=auto -lh --only-dirs $args" -ForegroundColor Cyan
    eza --icons=auto -lh --only-dirs @args
}
Set-Alias -Name 'ld' -Value Invoke-ListDirs -Scope Global -Force

# ---------------------------------------------------------------------------
# Neovim
# ---------------------------------------------------------------------------

function global:Invoke-Neovim {
    Write-Host "→ nvim $args" -ForegroundColor Cyan
    nvim @args
}
Set-Alias -Name 'n'    -Value Invoke-Neovim -Scope Global -Force
Set-Alias -Name 'edit' -Value Invoke-Neovim -Scope Global -Force

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------

function global:Invoke-Git {
    Write-Host "→ git $args" -ForegroundColor Cyan
    git @args
}
Set-Alias -Name 'g' -Value Invoke-Git -Scope Global -Force

function global:Invoke-GitBranch {
    Write-Host "→ git branch $args" -ForegroundColor Cyan
    git branch @args
}
Set-Alias -Name 'gb' -Value Invoke-GitBranch -Scope Global -Force

function global:Invoke-GitCheckout {
    Write-Host "→ git checkout $args" -ForegroundColor Cyan
    git checkout @args
}
Set-Alias -Name 'gco' -Value Invoke-GitCheckout -Scope Global -Force

function global:Invoke-GitCommit {
    Write-Host "→ git commit -m $args" -ForegroundColor Cyan
    git commit -m @args
}
Set-Alias -Name 'gc' -Value Invoke-GitCommit -Scope Global -Force

function global:Invoke-GitCommitVerbose {
    Write-Host '→ git commit -v' -ForegroundColor Cyan
    git commit -v @args
}
Set-Alias -Name 'gcv' -Value Invoke-GitCommitVerbose -Scope Global -Force

function global:Invoke-GitClone {
    Write-Host "→ git clone $args" -ForegroundColor Cyan
    git clone @args
}
Set-Alias -Name 'gcl' -Value Invoke-GitClone -Scope Global -Force

function global:Invoke-GitShow {
    Write-Host "→ git show $args" -ForegroundColor Cyan
    git show @args
}
Set-Alias -Name 'gsh' -Value Invoke-GitShow -Scope Global -Force

function global:Invoke-GitPush {
    Write-Host "→ git push $args" -ForegroundColor Cyan
    git push @args
}
Set-Alias -Name 'gp' -Value Invoke-GitPush -Scope Global -Force

function global:Invoke-GitPull {
    Write-Host "→ git pull $args" -ForegroundColor Cyan
    git pull @args
}
Set-Alias -Name 'gl' -Value Invoke-GitPull -Scope Global -Force

function global:Invoke-GitStatus {
    Write-Host '→ git status' -ForegroundColor Cyan
    git status @args
}
Set-Alias -Name 'gst' -Value Invoke-GitStatus -Scope Global -Force

function global:Invoke-GitAdd {
    Write-Host "→ git add $args" -ForegroundColor Cyan
    git add @args
}
Set-Alias -Name 'ga' -Value Invoke-GitAdd -Scope Global -Force

# Note: ga. is named gaa in PowerShell — trailing dot conflicts with member-access syntax.
function global:Invoke-GitAddAll {
    Write-Host '→ git add .' -ForegroundColor Cyan
    git add .
}
Set-Alias -Name 'gaa' -Value Invoke-GitAddAll -Scope Global -Force

# git log variants
function global:Invoke-GitLog {
    Write-Host "→ git log $args" -ForegroundColor Cyan
    git log @args
}
Set-Alias -Name 'glo' -Value Invoke-GitLog -Scope Global -Force

function global:Invoke-GitLogShort {
    Write-Host '→ git log --oneline' -ForegroundColor Cyan
    git log --oneline @args
}
Set-Alias -Name 'glo-short' -Value Invoke-GitLogShort -Scope Global -Force

function global:Invoke-GitLogGraph {
    Write-Host '→ git log --graph --oneline --decorate' -ForegroundColor Cyan
    git log --graph --oneline --decorate @args
}
Set-Alias -Name 'glo-graph' -Value Invoke-GitLogGraph -Scope Global -Force

function global:Invoke-GitLogAll {
    Write-Host '→ git log --all --oneline --decorate' -ForegroundColor Cyan
    git log --all --oneline --decorate @args
}
Set-Alias -Name 'glo-all' -Value Invoke-GitLogAll -Scope Global -Force

function global:Invoke-GitLogStat {
    Write-Host '→ git log --stat' -ForegroundColor Cyan
    git log --stat @args
}
Set-Alias -Name 'glo-stat' -Value Invoke-GitLogStat -Scope Global -Force

function global:Invoke-GitLogFile {
    Write-Host '→ git log --name-only' -ForegroundColor Cyan
    git log --name-only @args
}
Set-Alias -Name 'glo-file' -Value Invoke-GitLogFile -Scope Global -Force

# git diff variants
function global:Invoke-GitDiff {
    Write-Host "→ git diff $args" -ForegroundColor Cyan
    git diff @args
}
Set-Alias -Name 'gd' -Value Invoke-GitDiff -Scope Global -Force

function global:Invoke-GitDiffStaged {
    Write-Host '→ git diff --staged' -ForegroundColor Cyan
    git diff --staged @args
}
Set-Alias -Name 'gd-staged' -Value Invoke-GitDiffStaged -Scope Global -Force

function global:Invoke-GitDiffStat {
    Write-Host '→ git diff --stat' -ForegroundColor Cyan
    git diff --stat @args
}
Set-Alias -Name 'gd-stat' -Value Invoke-GitDiffStat -Scope Global -Force

function global:Invoke-GitDiffWord {
    Write-Host '→ git diff --word-diff' -ForegroundColor Cyan
    git diff --word-diff @args
}
Set-Alias -Name 'gd-word' -Value Invoke-GitDiffWord -Scope Global -Force

# ---------------------------------------------------------------------------
# Ruby and Ruby on Rails
# ---------------------------------------------------------------------------

function global:Invoke-BundleInstall {
    Write-Host '→ bundle install' -ForegroundColor Cyan
    bundle install @args
}
Set-Alias -Name 'bi' -Value Invoke-BundleInstall -Scope Global -Force

function global:Invoke-BundleExec {
    Write-Host "→ bundle exec $args" -ForegroundColor Cyan
    bundle exec @args
}
Set-Alias -Name 'be' -Value Invoke-BundleExec -Scope Global -Force

function global:Invoke-BundleUpdate {
    Write-Host '→ bundle update' -ForegroundColor Cyan
    bundle update @args
}
Set-Alias -Name 'bu' -Value Invoke-BundleUpdate -Scope Global -Force

function global:Invoke-BundleList {
    Write-Host '→ bundle list' -ForegroundColor Cyan
    bundle list @args
}
Set-Alias -Name 'bl' -Value Invoke-BundleList -Scope Global -Force

function global:Invoke-RailsConsole {
    Write-Host '→ bundle exec rails console' -ForegroundColor Cyan
    bundle exec rails console @args
}
Set-Alias -Name 'r-console' -Value Invoke-RailsConsole -Scope Global -Force

function global:Invoke-RailsServer {
    Write-Host '→ bundle exec rails server -b 0.0.0.0' -ForegroundColor Cyan
    bundle exec rails server -b 0.0.0.0 @args
}
Set-Alias -Name 'r-server' -Value Invoke-RailsServer -Scope Global -Force

function global:Invoke-RailsMigrate {
    Write-Host '→ bundle exec rails db:migrate' -ForegroundColor Cyan
    bundle exec rails db:migrate @args
}
Set-Alias -Name 'r-migrate' -Value Invoke-RailsMigrate -Scope Global -Force

function global:Invoke-RailsRollback {
    Write-Host '→ bundle exec rails db:rollback' -ForegroundColor Cyan
    bundle exec rails db:rollback @args
}
Set-Alias -Name 'r-rollback' -Value Invoke-RailsRollback -Scope Global -Force

function global:Invoke-RailsGenerate {
    Write-Host "→ bundle exec rails g $args" -ForegroundColor Cyan
    bundle exec rails g @args
}
Set-Alias -Name 'r-gen' -Value Invoke-RailsGenerate -Scope Global -Force

# ---------------------------------------------------------------------------
# Node / JavaScript / TypeScript
# ---------------------------------------------------------------------------

# j-run [-l] [<script>]  — list scripts or run a package.json script
function global:Invoke-JsRun {
    $pm = Get-NodePackageManager
    if ($args[0] -eq '-l') {
        Write-Host "Package manager: $pm" -ForegroundColor Yellow
        if (Test-Path 'package.json') {
            $pkg = Get-Content 'package.json' -Raw | ConvertFrom-Json
            $pkg.scripts.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name): $($_.Value)"
            }
        } else {
            Write-Warning 'No package.json found'
        }
        return
    }
    Write-Host "→ $pm run $args" -ForegroundColor Cyan
    switch ($pm) {
        'bun'  { bun  run @args }
        'pnpm' { pnpm run @args }
        'yarn' { yarn run @args }
        default { npm run @args }
    }
}
Set-Alias -Name 'j-run' -Value Invoke-JsRun -Scope Global -Force

function global:Invoke-JsAdd {
    $pm = Get-NodePackageManager
    Write-Host "→ $pm add $args" -ForegroundColor Cyan
    switch ($pm) {
        'bun'  { bun  add          @args }
        'pnpm' { pnpm add          @args }
        'yarn' { yarn add          @args }
        default { npm  install     @args }
    }
}
Set-Alias -Name 'j-add' -Value Invoke-JsAdd -Scope Global -Force

function global:Invoke-JsAddDev {
    $pm = Get-NodePackageManager
    Write-Host "→ $pm add --dev $args" -ForegroundColor Cyan
    switch ($pm) {
        'bun'  { bun  add --dev        @args }
        'pnpm' { pnpm add --save-dev   @args }
        'yarn' { yarn add --dev        @args }
        default { npm  install --save-dev @args }
    }
}
Set-Alias -Name 'j-addd' -Value Invoke-JsAddDev -Scope Global -Force

function global:Invoke-JsBuild {
    $pm = Get-NodePackageManager
    Write-Host "→ $pm run build" -ForegroundColor Cyan
    Invoke-JsRun build
}
Set-Alias -Name 'j-build' -Value Invoke-JsBuild -Scope Global -Force

function global:Invoke-JsLint {
    $pm = Get-NodePackageManager
    Write-Host "→ $pm run lint" -ForegroundColor Cyan
    Invoke-JsRun lint
}
Set-Alias -Name 'j-lint' -Value Invoke-JsLint -Scope Global -Force

function global:Invoke-JsTest {
    $pm = Get-NodePackageManager
    Write-Host "→ $pm test" -ForegroundColor Cyan
    switch ($pm) {
        'bun'  { bun  test }
        'pnpm' { pnpm test }
        'yarn' { yarn test }
        default { npm test }
    }
}
Set-Alias -Name 'j-test' -Value Invoke-JsTest -Scope Global -Force

function global:Invoke-JsCheck {
    if (-not (Test-Path 'package.json')) {
        Write-Warning 'No package.json found'; return
    }
    $pkg = Get-Content 'package.json' -Raw | ConvertFrom-Json
    if (-not $pkg.scripts.check) {
        Write-Warning "No 'check' script found in package.json"; return
    }
    $pm = Get-NodePackageManager
    Write-Host "→ $pm run check" -ForegroundColor Cyan
    Invoke-JsRun check
}
Set-Alias -Name 'j-check' -Value Invoke-JsCheck -Scope Global -Force

# Frameworks — delegate to Invoke-JsRun with the conventional script name.

# Astro
function global:Invoke-AstroDev     { Write-Host "→ $(Get-NodePackageManager) run dev (Astro)"     -ForegroundColor Cyan; Invoke-JsRun dev }
function global:Invoke-AstroBuild   { Write-Host "→ $(Get-NodePackageManager) run build (Astro)"   -ForegroundColor Cyan; Invoke-JsRun build }
function global:Invoke-AstroPreview { Write-Host "→ $(Get-NodePackageManager) run preview (Astro)" -ForegroundColor Cyan; Invoke-JsRun preview }
Set-Alias -Name 'j-astro-dev'     -Value Invoke-AstroDev     -Scope Global -Force
Set-Alias -Name 'j-astro-build'   -Value Invoke-AstroBuild   -Scope Global -Force
Set-Alias -Name 'j-astro-preview' -Value Invoke-AstroPreview -Scope Global -Force

# Next.js
function global:Invoke-NextDev   { Write-Host "→ $(Get-NodePackageManager) run dev (Next.js)"   -ForegroundColor Cyan; Invoke-JsRun dev }
function global:Invoke-NextBuild { Write-Host "→ $(Get-NodePackageManager) run build (Next.js)" -ForegroundColor Cyan; Invoke-JsRun build }
function global:Invoke-NextStart { Write-Host "→ $(Get-NodePackageManager) run start (Next.js)" -ForegroundColor Cyan; Invoke-JsRun start }
Set-Alias -Name 'j-next-dev'   -Value Invoke-NextDev   -Scope Global -Force
Set-Alias -Name 'j-next-build' -Value Invoke-NextBuild -Scope Global -Force
Set-Alias -Name 'j-next-start' -Value Invoke-NextStart -Scope Global -Force

# Vite
function global:Invoke-ViteDev     { Write-Host "→ $(Get-NodePackageManager) run dev (Vite)"     -ForegroundColor Cyan; Invoke-JsRun dev }
function global:Invoke-ViteBuild   { Write-Host "→ $(Get-NodePackageManager) run build (Vite)"   -ForegroundColor Cyan; Invoke-JsRun build }
function global:Invoke-VitePreview { Write-Host "→ $(Get-NodePackageManager) run preview (Vite)" -ForegroundColor Cyan; Invoke-JsRun preview }
Set-Alias -Name 'j-vite-dev'     -Value Invoke-ViteDev     -Scope Global -Force
Set-Alias -Name 'j-vite-build'   -Value Invoke-ViteBuild   -Scope Global -Force
Set-Alias -Name 'j-vite-preview' -Value Invoke-VitePreview -Scope Global -Force

# React Native / Expo
function global:Invoke-ExpoStart   { Write-Host "→ $(Get-NodePackageManager) run start (Expo)"   -ForegroundColor Cyan; Invoke-JsRun start }
function global:Invoke-ExpoAndroid { Write-Host "→ $(Get-NodePackageManager) run android (Expo)" -ForegroundColor Cyan; Invoke-JsRun android }
function global:Invoke-ExpoIos     { Write-Host "→ $(Get-NodePackageManager) run ios (Expo)"     -ForegroundColor Cyan; Invoke-JsRun ios }
Set-Alias -Name 'j-expo-start'   -Value Invoke-ExpoStart   -Scope Global -Force
Set-Alias -Name 'j-expo-android' -Value Invoke-ExpoAndroid -Scope Global -Force
Set-Alias -Name 'j-expo-ios'     -Value Invoke-ExpoIos     -Scope Global -Force

# Hono
function global:Invoke-HonoDev   { Write-Host "→ $(Get-NodePackageManager) run dev (Hono)"   -ForegroundColor Cyan; Invoke-JsRun dev }
function global:Invoke-HonoBuild { Write-Host "→ $(Get-NodePackageManager) run build (Hono)" -ForegroundColor Cyan; Invoke-JsRun build }
Set-Alias -Name 'j-hono-dev'   -Value Invoke-HonoDev   -Scope Global -Force
Set-Alias -Name 'j-hono-build' -Value Invoke-HonoBuild -Scope Global -Force
