function zl --description 'List all zoxide entries (zoxide query --list)'
    if not command -q zoxide
        echo "error: zoxide is not installed" >&2
        return 1
    end
    zoxide query --list $argv
end
