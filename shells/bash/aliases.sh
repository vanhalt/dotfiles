#!/usr/bin/env bash
# =============================================================================
# Shell Aliases — Bash
# Source from ~/.bashrc:  source ~/dotfiles/shells/bash/aliases.sh
# =============================================================================

# ---------------------------------------------------------------------------
# OS — Package Manager Detection
# Precedence: apt → yay → pacman  (bash + fish only, not PowerShell)
# ---------------------------------------------------------------------------

_detect_pm() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v yay &>/dev/null; then
        echo "yay"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    fi
}

update() {
    case "$(_detect_pm)" in
        apt)    sudo apt update ;;
        yay)    yay -Sy ;;
        pacman) sudo pacman -Sy ;;
        *)      echo "error: no supported package manager found (apt, yay, pacman)" >&2; return 1 ;;
    esac
}

upgrade() {
    case "$(_detect_pm)" in
        apt)    sudo apt upgrade -y ;;
        yay)    yay -Syu ;;
        pacman) sudo pacman -Syu ;;
        *)      echo "error: no supported package manager found (apt, yay, pacman)" >&2; return 1 ;;
    esac
}

search() {
    case "$(_detect_pm)" in
        apt)    apt search "$@" ;;
        yay)    yay -Ss "$@" ;;
        pacman) pacman -Ss "$@" ;;
        *)      echo "error: no supported package manager found (apt, yay, pacman)" >&2; return 1 ;;
    esac
}

# ---------------------------------------------------------------------------
# cd / zoxide
# If zoxide is installed (and initialised via `eval "$(zoxide init bash)"`),
# .. and ... will use `z` for frecency-based navigation.
# Extra aliases are only defined when zoxide is available.
# ---------------------------------------------------------------------------

if command -v zoxide &>/dev/null; then
    alias ..='z ..'
    alias ...='z ../..'
    # zoxide already provides `z` and `zi` via `zoxide init bash`
    alias zl='zoxide query --list'
    alias za='zoxide add'
    alias zr='zoxide remove'
    alias zq='zoxide query'
else
    alias ..='cd ..'
    alias ...='cd ../..'
fi

# ---------------------------------------------------------------------------
# ls / eza
# eza is used when available; plain ls is the fallback.
# Advanced eza aliases (lt, lg, ll-tree, ld) are only defined with eza.
# ---------------------------------------------------------------------------

if command -v eza &>/dev/null; then
    alias l='eza --icons=auto'
    alias la='eza --icons=auto -a'
    alias ll='eza --icons=auto -lh'
    alias lla='eza --icons=auto -lha'
    # Advanced eza
    alias lt='eza --icons=auto --tree'
    alias lg='eza --icons=auto -lh --git'
    alias ll-tree='eza --icons=auto --tree -lh'
    alias ld='eza --icons=auto -lh --only-dirs'
else
    alias l='ls'
    alias la='ls -a'
    alias ll='ls -lh'
    alias lla='ls -lha'
fi

# ---------------------------------------------------------------------------
# Neovim
# ---------------------------------------------------------------------------

alias n='nvim'
alias edit='nvim'

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------

alias g='git'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit -m'
alias gcv='git commit -v'
alias gcl='git clone'
alias gsh='git show'
alias gp='git push'
alias gl='git pull'
alias gst='git status'
alias ga='git add'
alias 'ga.'='git add .'

# git log variants
alias glo='git log'
alias glo-short='git log --oneline'
alias glo-graph='git log --graph --oneline --decorate'
alias glo-all='git log --all --oneline --decorate'
alias glo-stat='git log --stat'
alias glo-file='git log --name-only'

# git diff variants
alias gd='git diff'
alias gd-staged='git diff --staged'
alias gd-stat='git diff --stat'
alias gd-word='git diff --word-diff'

# ---------------------------------------------------------------------------
# Ruby and Ruby on Rails
# ---------------------------------------------------------------------------

alias bi='bundle install'
alias be='bundle exec'
alias bu='bundle update'
alias bl='bundle list'
alias r-console='bundle exec rails console'
alias r-server='bundle exec rails server -b 0.0.0.0'
alias r-migrate='bundle exec rails db:migrate'
alias r-rollback='bundle exec rails db:rollback'
alias r-gen='bundle exec rails g'

# ---------------------------------------------------------------------------
# Ruby and Ruby on Rails
# ---------------------------------------------------------------------------
alias e='yazi'

# ---------------------------------------------------------------------------
# Node / JavaScript / TypeScript
# ---------------------------------------------------------------------------

# Detect package manager.
# Priority: .jmanager file (walked up from $PWD) → lock files → npm default.
_j_pm() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.jmanager" ]]; then
            tr -d '[:space:]' < "$dir/.jmanager"
            return
        fi
        dir="$(dirname "$dir")"
    done
    if [[ -f "bun.lockb" || -f "bun.lock" ]]; then echo "bun"
    elif [[ -f "pnpm-lock.yaml" ]]; then             echo "pnpm"
    elif [[ -f "yarn.lock" ]]; then                  echo "yarn"
    else                                             echo "npm"
    fi
}

# j-run [-l] [<script>] — list scripts or run a package.json script
j-run() {
    local pm
    pm="$(_j_pm)"
    if [[ "$1" == "-l" ]]; then
        echo "Package manager: $pm"
        if [[ -f "package.json" ]]; then
            node -e "
const s = require('./package.json').scripts || {};
Object.entries(s).forEach(([k, v]) => console.log('  ' + k + ': ' + v));
"
        else
            echo "error: no package.json found" >&2
            return 1
        fi
        return
    fi
    case "$pm" in
        bun)  bun  run "$@" ;;
        pnpm) pnpm run "$@" ;;
        yarn) yarn run "$@" ;;
        *)    npm  run "$@" ;;
    esac
}

# j-add <package>  — add a runtime dependency
j-add() {
    local pm
    pm="$(_j_pm)"
    case "$pm" in
        bun)  bun  add          "$@" ;;
        pnpm) pnpm add          "$@" ;;
        yarn) yarn add          "$@" ;;
        *)    npm  install      "$@" ;;
    esac
}

# j-addd <package>  — add a dev dependency
j-addd() {
    local pm
    pm="$(_j_pm)"
    case "$pm" in
        bun)  bun  add --dev        "$@" ;;
        pnpm) pnpm add --save-dev   "$@" ;;
        yarn) yarn add --dev        "$@" ;;
        *)    npm  install --save-dev "$@" ;;
    esac
}

j-build() { j-run build; }
j-lint()  { j-run lint; }

# j-test — runs the test runner (bun/pnpm/yarn have their own test commands)
j-test() {
    local pm
    pm="$(_j_pm)"
    case "$pm" in
        bun)  bun  test ;;
        pnpm) pnpm test ;;
        yarn) yarn test ;;
        *)    npm  test ;;
    esac
}

# j-check — runs the `check` script only if it exists in package.json
j-check() {
    if [[ ! -f "package.json" ]]; then
        echo "error: no package.json found" >&2
        return 1
    fi
    local has_check
    has_check=$(node -e "
const s = require('./package.json').scripts || {};
console.log(s.check ? 'yes' : 'no');
" 2>/dev/null)
    if [[ "$has_check" != "yes" ]]; then
        echo "error: no 'check' script in package.json" >&2
        return 1
    fi
    j-run check
}

# Frameworks — delegate to j-run with the conventional script name.
# Astro
j-astro-dev()     { j-run dev; }
j-astro-build()   { j-run build; }
j-astro-preview() { j-run preview; }

# Next.js
j-next-dev()      { j-run dev; }
j-next-build()    { j-run build; }
j-next-start()    { j-run start; }

# Vite
j-vite-dev()      { j-run dev; }
j-vite-build()    { j-run build; }
j-vite-preview()  { j-run preview; }

# React Native / Expo
j-expo-start()    { j-run start; }
j-expo-android()  { j-run android; }
j-expo-ios()      { j-run ios; }

# Hono
j-hono-dev()      { j-run dev; }
j-hono-build()    { j-run build; }
