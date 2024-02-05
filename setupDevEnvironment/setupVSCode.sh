#!/bin/bash 
set -e

currentDir="$(dirname ${BASH_SOURCE[0]})"

vscodeExeDir="$LOCALAPPDATA/Programs/Microsoft VS Code Insiders"
vscodeSettingsDir="$APPDATA/Code - Insiders/User"

source "${currentDir}/../util/printUtil.sh"

install_vscode_extensions() {
	print_section_header "$1"
	
	extensions_from_json=($(jq -r "(.$2) | @sh" "${currentDir}/data/vsCodeExtensions.json"))

	for extension in "${extensions_from_json[@]}"
	do
		print_bullet "Installing ${extension}"
		# code-insiders ext install $extension --force || exit 1
	done
}

insert_vscode_settings() {
	print_section_header "Setting Up Settings for VSCode Insiders"

	print_bullet "Check if User Settings Exist Already"
	if [ $(cd "$vscodeSettingsDir" && test -f "settings.json") ]; then
		print_bullet "Existing User Settings Found"
	else
		print_bullet "No User Settings Found. Creating settings file"
		(cd "$vscodeSettingsDir" && echo "{}" > "settings.json")
	fi

	print_bullet "Setting up settings"
	currentSettings=$(cd "$vscodeSettingsDir" && jq "." "settings.json")
	newSettings=$(jq "." "${currentDir}/data/vsCodeSettings.json")

	mergedSetttings=$(echo "$currentSettings" "$newSettings" | jq -s add)
	(cd "$vscodeSettingsDir" && echo $mergedSetttings > "settings.json")
}

print_section_header "Setting Up VSCode Insiders"
# --------------------------------------
# Init Visual Studio Code Folders
# --------------------------------------
(cd "$vscodeExeDir" && eval "./Code\ -\ Insiders.exe") &
while [ ! -d "$vscodeSettingsDir" ]; do sleep 2; done;
Taskkill //F //IM "Code - Insiders.exe"

# --------------------------------------
# Extension Setup
# --------------------------------------
install_vscode_extensions "Setting Up General Extensions" "generalExtensions"
install_vscode_extensions "Setting Up JS/TS Extensions" "jsExtensions"
install_vscode_extensions "Setting Up Dot Net Extensions" "dotNetExtensions"
install_vscode_extensions "Setting Up Python Extensions" "pythonExtensions"

# --------------------------------------
# Settings Stup
# --------------------------------------
insert_vscode_settings

exit 0