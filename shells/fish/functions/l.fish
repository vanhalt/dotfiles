function l --description 'List files (eza with icons when available)'
    if command -q eza
        eza --icons=auto $argv
    else
        ls $argv
    end
end
