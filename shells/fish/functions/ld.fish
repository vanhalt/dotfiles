function ld --description 'List directories only in long view (requires eza)'
    if command -q eza
        eza --icons=auto -lh --only-dirs $argv
    else
        echo "error: eza is not installed (required for directory-only view)" >&2
        return 1
    end
end
