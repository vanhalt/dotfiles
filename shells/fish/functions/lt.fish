function lt --description 'Tree view of files (requires eza)'
    if command -q eza
        eza --icons=auto --tree $argv
    else
        echo "error: eza is not installed (required for tree view)" >&2
        return 1
    end
end
