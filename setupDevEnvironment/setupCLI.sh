#!/bin/bash 
set -e

currentDir="$(dirname ${BASH_SOURCE[0]})"

source "${currentDir}/../util/printUtil.sh"

exit_on_error() {
	print_pause
	exit 1
}

set_zsh_prop() {
    package=$1

    if ! command -v foo &> /dev/null; then
        print_bullet "Installing ${package}"
        sudo apt install $package -q -y
    else
        print_bullet "Package ${package} already installed"
        sudo apt upgrade $package -q -y
    fi
}

# --------------------------------------
# Main
# --------------------------------------
print_section_header "Setting Up CLI"

print_section_sub_header "Installing Oh My ZSH"
print_bullet "Installing Oh My ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_section_sub_header "Setting Theme"

print_bullet "Installing Spaceship"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
