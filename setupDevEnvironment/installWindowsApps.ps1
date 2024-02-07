#!/usr/bin/env pwsh

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	Write-Warning "The script needs to be executed with administrator privileges."
	Break
}

function Write-Header {
		param (
        [string]$Header
    )

    Write-Output "`n===== |$Header| ====="
}

function Write-SubHeader {
		param (
        [string]$SubHeader
    )
		
    Write-Output "`n==> $SubHeader"
}

function Install-WinGet {
		param (
				[Parameter(Mandatory=$true)]
        [string]$Extension,
				[Parameter()]
				[bool]$Upgarde
    )
		
    Write-SubHeader "Installing $extension"

		if ( $Upgarde )
		{
			winget install --id=$extension --source=winget --exact --accept-source-agreements --accept-package-agreements --silent
		}
		else
		{
			winget install --id=$extension --no-upgrade --source=winget --exact --accept-source-agreements --accept-package-agreements --silent
		}
}

#Enabling WSL
Write-Header "Installing WSL"
Write-SubHeader "Checking for WSL"
wsl -l -v | out-null
if ( -not ( $? ) )
{
	Write-Output "No Version of WSL Found"
	Write-SubHeader "Installing WSL"
	wsl --install -d Ubuntu	
	read-host “Press ENTER Ubuntu is done setting up...”
}
else
{
	Write-Output "WSL already installed"
}

# Windows
Write-Header "Downloading Extensions To Microsoft Terminals"
$windowExtensions = @(
	'Microsoft.PowerToys'
	'Microsoft.WindowsTerminal.Preview'
	'Microsoft.PowerShell.Preview'
	'jqlang.jq'
)

foreach ( $extension in $windowExtensions )
{
	Install-WinGet $extension
}

# CLI Customization

# Git
Write-Header "Downloading Git + Github"
$gitExtensions = @(
	'Git.Git'
	'GitHub.cli'
)

foreach ( $extension in $gitExtensions )
{
	Install-WinGet $extension
}

# Development Enviroment
Write-Header "Downloading Pre-Reqs for Development Languages"
$devExtensions = @(
	'Microsoft.DotNet.SDK.7'
	'Microsoft.DotNet.DesktopRuntime.7'
	'Microsoft.DotNet.AspNetCore.7'
	'Yarn.Yarn'
	'pnpm'
	'Python.Python.3.12'
)

foreach ( $extension in $devExtensions )
{
	Install-WinGet $extension
}

# Coding IDE
Write-Header "Downloading Development Applications"
$ideExtensions = @(
	'Microsoft.VisualStudioCode'
	'Microsoft.VisualStudioCode.CLI'
)

foreach ( $extension in $ideExtensions )
{
	Install-WinGet $extension $true
}
