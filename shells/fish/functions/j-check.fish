function j-check --description 'Run the check script if it exists in package.json'
    if not test -f package.json
        echo "error: no package.json found" >&2
        return 1
    end
    set -l has_check (node -e "
const s = require('./package.json').scripts || {};
console.log(s.check ? 'yes' : 'no');
" 2>/dev/null)
    if test "$has_check" != yes
        echo "error: no 'check' script in package.json" >&2
        return 1
    end
    j-run check
end
