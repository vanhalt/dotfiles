function lla --description 'Long list all files including hidden (eza when available)'
    if command -q eza
        eza --icons=auto -lha $argv
    else
        ls -lha $argv
    end
end
