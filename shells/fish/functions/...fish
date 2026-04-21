# Function name: ..
# File is named `...fish` because fish appends .fish to the function name for autoloading.
# Note: this file starts with a dot — use `ls -a` to see it in the functions directory.
function .. --description 'Go up one directory (uses zoxide when available)'
    if command -q zoxide
        z ..
    else
        cd ..
    end
end
