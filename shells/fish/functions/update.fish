function update --description 'Update package index (apt / yay / pacman)'
    switch (_detect_pm)
        case apt
            sudo apt update
        case yay
            yay -Sy
        case pacman
            sudo pacman -Sy
        case '*'
            echo "error: no supported package manager found (apt, yay, pacman)" >&2
            return 1
    end
end
