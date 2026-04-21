# Private helper — detect the Node/JS package manager.
# Priority: .jmanager file (walked up from $PWD) → lock files → npm default.
function _j_pm
    set -l dir $PWD
    while test "$dir" != /
        if test -f "$dir/.jmanager"
            string trim < "$dir/.jmanager"
            return
        end
        set dir (dirname $dir)
    end
    if test -f bun.lockb; or test -f bun.lock
        echo bun
    else if test -f pnpm-lock.yaml
        echo pnpm
    else if test -f yarn.lock
        echo yarn
    else if test -f package-lock.json
        echo npm
    else
        echo npm
    end
end
