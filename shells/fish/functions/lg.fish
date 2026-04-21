function lg --description 'Long list with git status (requires eza)'
    if command -q eza
        eza --icons=auto -lh --git $argv
    else
        echo "error: eza is not installed (required for git status view)" >&2
        return 1
    end
end
