#!/bin/bash 
set -e

currentDir="$(dirname ${BASH_SOURCE[0]})"

source "${currentDir}/../util/printUtil.sh"

exit_on_error() {
	print_pause
	exit 1
}

install_package() {
    package=$1

    if ! command -v foo &> /dev/null; then
        print_bullet "Installing ${package}"
        wsl sudo apt install $package -q -y
    else
        print_bullet "Package ${package} already installed"
        wsl sudo apt upgrade $package -q -y
    fi
}

install_node() {
    if ! command -v foo &> /dev/null; then
        print_bullet "Installing NVM"
        wsl curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        wsl nvm install --lts
        wsl nvm install node
    else
        print_bullet "Package NVM already installed"
    fi
}

PACKAGES=('pnpm')

# --------------------------------------
# Main
# --------------------------------------
print_section_header "Setting Up CLI Packages"
print_section_sub_header "Downloading Packages"
for package in "${PACKAGES[@]}"
do
    install_package $package
done
