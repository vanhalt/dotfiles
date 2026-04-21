function la --description 'List all files including hidden (eza when available)'
    if command -q eza
        eza --icons=auto -a $argv
    else
        ls -a $argv
    end
end
