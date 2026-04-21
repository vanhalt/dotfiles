function ll-tree --description 'Long tree view (requires eza)'
    if command -q eza
        eza --icons=auto --tree -lh $argv
    else
        echo "error: eza is not installed (required for tree view)" >&2
        return 1
    end
end
