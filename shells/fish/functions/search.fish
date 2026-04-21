function search --description 'Search for a package (apt / yay / pacman)'
    switch (_detect_pm)
        case apt
            apt search $argv
        case yay
            yay -Ss $argv
        case pacman
            pacman -Ss $argv
        case '*'
            echo "error: no supported package manager found (apt, yay, pacman)" >&2
            return 1
    end
end
