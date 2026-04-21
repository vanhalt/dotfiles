function ll --description 'Long list with human-readable sizes (eza when available)'
    if command -q eza
        eza --icons=auto -lh $argv
    else
        ls -lh $argv
    end
end
