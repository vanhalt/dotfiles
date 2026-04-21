# Private helper — detect the system package manager.
# Precedence: apt → yay → pacman
function _detect_pm
    if command -q apt
        echo apt
    else if command -q yay
        echo yay
    else if command -q pacman
        echo pacman
    end
end
