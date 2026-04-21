function j-test --description 'Run tests (bun/pnpm/yarn/npm test)'
    set -l pm (_j_pm)
    switch $pm
        case bun
            bun test
        case pnpm
            pnpm test
        case yarn
            yarn test
        case '*'
            npm test
    end
end
