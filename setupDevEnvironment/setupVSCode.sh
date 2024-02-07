#!/bin/bash 
set -e

currentDir="$(dirname ${BASH_SOURCE[0]})"

vscodeExeDir="$LOCALAPPDATA/Programs/Microsoft VS Code"
vscodeExtenstionsDir="$USERPROFILE/.vscode/extensions"
vscodeSettingsDir="$APPDATA/Code/User"

source "${currentDir}/../util/printUtil.sh"

# --------------------------------------
# Init VSCode Functions
# --------------------------------------
init_vscode() {
	print_section_sub_header "Initializing VSCode Files"
	print_bullet "Opening VSCode To Generate Init Files"
	(cd "$vscodeExeDir" && eval "./Code.exe") &
	while [ ! -d "$vscodeSettingsDir" ]; do sleep 2; done;

	print_bullet "Closing VSCode After Files Generated"
	Taskkill //F //IM "Code.exe" &>/dev/null
}

# --------------------------------------
# Extension Setup Functions
# --------------------------------------

insert_vscode_extensions() {
	print_section_header "Setting Up VSCode Extensions Files"

	install_vscode_extensions "Setting Up General Extensions" "generalExtensions"
	install_vscode_extensions "Setting Up JS/TS Extensions" "jsExtensions"
	install_vscode_extensions "Setting Up Dot Net Extensions" "dotNetExtensions"
	install_vscode_extensions "Setting Up Python Extensions" "pythonExtensions"
}

install_vscode_extensions() {
	print_section_sub_header "$1"
	
	extensions_from_json=($(jq -r "(.$2) | @sh" "${currentDir}/data/vsCodeExtensions.json"))

	for extension in "${extensions_from_json[@]}"
	do
		print_bullet "Installing ${extension}"
		code --install-extension "${extension//\'/}" &>/dev/null || (print_bullet "${extension} failed To install" && exit 1)
	done
}

# --------------------------------------
# Settings Setup Functions 
# --------------------------------------

insert_vscode_settings() {
	print_section_header "Setting Up Settings for VSCode"

	print_section_sub_header "Checking User Settings"
	(cd "$vscodeSettingsDir" && test -f './settings.json') && file_exists=true

	if [[ $file_exists = true ]] ; then
		print_bullet "Existing User Settings Found"
	else
		print_bullet "No User Settings Found"
		print_bullet "Creating settings file"
		(cd "$vscodeSettingsDir" && echo "{}" > "settings.json")
	fi

	print_section_sub_header "Merging in New Settings"
	currentSettings=$(cd "$vscodeSettingsDir" && jq "." "settings.json")
	newSettings=$(jq "." "${currentDir}/data/vsCodeSettings.json")

	mergedSetttings=$(echo "$currentSettings" "$newSettings" | jq -s add)
	(cd "$vscodeSettingsDir" && echo $mergedSetttings > "settings.json")
	print_bullet "Settings Merged In"
}

# --------------------------------------
# Main
# --------------------------------------
print_section_header "Setting Up VSCode"
init_vscode
insert_vscode_extensions
insert_vscode_settings

exit 0