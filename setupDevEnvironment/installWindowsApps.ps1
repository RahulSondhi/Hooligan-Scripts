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
	Write-SubHeader "Installing $extension"
  winget install $extension --exact --no-upgrade --accept-source-agreements --accept-package-agreements  
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
	Write-SubHeader "Installing $extension"
  winget install $extension --exact --no-upgrade --accept-source-agreements --accept-package-agreements 
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
	Write-SubHeader "Installing $extension"
  winget install $extension --exact --no-upgrade --accept-source-agreements --accept-package-agreements 
}

# Coding IDE
Write-Header "Downloading Development Applications"
$ideExtensions = @(
	'Microsoft.VisualStudioCode.Insiders'
	'Microsoft.VisualStudioCode.Insiders.CLI'
)

foreach ( $extension in $ideExtensions )
{
	Write-SubHeader "Installing $extension"
  winget install $extension --exact --no-upgrade --accept-source-agreements --accept-package-agreements 
}
