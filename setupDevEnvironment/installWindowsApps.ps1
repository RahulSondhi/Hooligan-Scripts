#!/usr/bin/env pwsh
Import-Module "$PSScriptRoot/../util/printUtil.ps1"
Import-Module "$PSScriptRoot/../util/installUtil.ps1"

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	Write-Warning "The script needs to be executed with administrator privileges."
	Break
}

# Windows Extensions
Write-Header "Downloading Extensions To Microsoft Terminals"
$windowExtensions = @(
	'Microsoft.PowerToys'
	'Microsoft.WindowsTerminal.Preview'
	'Microsoft.PowerShell.Preview'
	'jqlang.jq'
)

foreach ( $extension in $windowExtensions )
{
	Install-WinGet -Extension $extension -Upgrade
}

# Git
Write-Header "Downloading Git + Github"
$gitExtensions = @(
	'Git.Git'
	'GitHub.cli'
)

foreach ( $extension in $gitExtensions )
{
	Install-WinGet -Extension $extension
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
	Install-WinGet -Extension $extension
}

# Coding IDE
Write-Header "Downloading Development Applications"
$ideExtensions = @(
	'Microsoft.VisualStudioCode'
	'Microsoft.VisualStudioCode.CLI'
)

foreach ( $extension in $ideExtensions )
{
	Install-WinGet -Extension $extension -Upgrade
}
