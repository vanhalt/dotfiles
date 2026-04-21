function j-run --description 'Run a package.json script (use -l to list scripts)'
    set -l pm (_j_pm)
    if test "$argv[1]" = -l
        echo "Package manager: $pm"
        if test -f package.json
            node -e "
const s = require('./package.json').scripts || {};
Object.entries(s).forEach(([k, v]) => console.log('  ' + k + ': ' + v));
"
        else
            echo "error: no package.json found" >&2
            return 1
        end
        return
    end
    switch $pm
        case bun
            bun run $argv
        case pnpm
            pnpm run $argv
        case yarn
            yarn run $argv
        case '*'
            npm run $argv
    end
end
