function j-add --description 'Add a runtime dependency'
    set -l pm (_j_pm)
    switch $pm
        case bun
            bun add $argv
        case pnpm
            pnpm add $argv
        case yarn
            yarn add $argv
        case '*'
            npm install $argv
    end
end
