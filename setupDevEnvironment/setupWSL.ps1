#!/usr/bin/env pwsh
Import-Module "$PSScriptRoot/../util/printUtil.ps1"
Import-Module "$PSScriptRoot/../util/installUtil.ps1"

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	Write-Warning "The script needs to be executed with administrator privileges."
	Break
}

# Enabling WSL
Write-Header "Installing WSL"
Write-SubHeader "Checking for WSL"
wsl -l -v | out-null
if ( -not ( $? ) )
{
	Write-Output "No Version of WSL Found"
	Write-SubHeader "Installing WSL"
	wsl --install -d Ubuntu	
	read-host “Press ENTER Ubuntu is done setting up...”
    wsl sudo apt update
	wsl sudo apt upgrade
}
else
{
	Write-Output "WSL already installed"
}

# WSL Packages
Write-Header "Downloading Extensions To WSL"
$wslExtensions = @(
	'wget'
	'curl'
	'jq'
    'git'
	'zsh'
)

foreach ( $extension in $wslExtensions )
{
	Install-WSL -Extension $extension -Upgrade
}
