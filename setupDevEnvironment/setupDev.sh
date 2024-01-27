#!/bin/bash 
set -e

currentDir="$(dirname ${BASH_SOURCE[0]})"

source "${currentDir}/../util/printUtil.sh"

exit_on_error() {
	print_pause
	exit 1
}

check_winget() {
	print_section_header "Checking for WinGet"
	{
		winget --version >/dev/null 2>&1
		print_bullet "Winget Version Found: $(winget --version)"
	} || {
		print_bullet "Winget Not Found"
		print_bullet "Please Install Winget for current terminal"
		exit_on_error
	}
}

check_pwsh() {
	print_section_header "Checking for Powershell"
	{
		powershell -command "(Get-Variable PSVersionTable -ValueOnly).PSVersion" >/dev/null 2>&1
		print_bullet "Powershell Found"
	} || {
		print_bullet "Powershell Not Found"
		print_bullet "Please Install Powershell for current terminal"
		exit_on_error
	}
}

check_winget
check_pwsh

print_section_header "Installing Windows Apps"
powershell -File "${currentDir}/installWindowsApps.ps1"

print_pause
exit 0