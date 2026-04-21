function za --description 'Add a directory to the zoxide database'
    if not command -q zoxide
        echo "error: zoxide is not installed" >&2
        return 1
    end
    zoxide add $argv
end
