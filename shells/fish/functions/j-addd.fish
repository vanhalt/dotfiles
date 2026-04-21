function j-addd --description 'Add a dev dependency'
    set -l pm (_j_pm)
    switch $pm
        case bun
            bun add --dev $argv
        case pnpm
            pnpm add --save-dev $argv
        case yarn
            yarn add --dev $argv
        case '*'
            npm install --save-dev $argv
    end
end
