function upgrade --description 'Upgrade installed packages (apt / yay / pacman)'
    switch (_detect_pm)
        case apt
            sudo apt upgrade -y
        case yay
            yay -Syu
        case pacman
            sudo pacman -Syu
        case '*'
            echo "error: no supported package manager found (apt, yay, pacman)" >&2
            return 1
    end
end
