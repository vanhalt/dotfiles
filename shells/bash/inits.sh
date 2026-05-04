# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Ollama
export OLLAMA_ORIGINS=*

# fzf
eval "$(fzf --bash)"
# mise
eval "$($HOME/.local/bin/mise activate bash)"
# starship
eval "$(starship init bash)"
# zoxide
eval "$(zoxide init bash)"
