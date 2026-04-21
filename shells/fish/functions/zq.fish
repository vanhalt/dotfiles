function zq --description 'Query the zoxide database'
    if not command -q zoxide
        echo "error: zoxide is not installed" >&2
        return 1
    end
    zoxide query $argv
end
