#!/usr/bin/env pwsh
Write-Output "Setting Up VSCode Insiders"

Write-Output "Setting Up Profile"
code-insiders --profile Hooligan

Write-Output "Setting Up General Extensions"
$generalExtensions = @(
	#	UI
	'oderwat.indent-rainbow'
	'zhuangtongfa.material-theme'
	'vscode-icons-team.vscode-icons'
	'mechatroner.rainbow-csv'
	'aaron-bond.better-comments'
	# Productivity Add Ons
	'wix.vscode-import-cost'
	'chrmarti.regex'
	'Gruntfuggly.todo-tree'
	'streetsidesoftware.code-spell-checker'
	'quicktype.quicktype'
	'pranaygp.vscode-css-peek'
	'kamikillerto.vscode-colorize'
	# Linting
	'EditorConfig.EditorConfig'
	'esbenp.prettier-vscode'
	'DavidAnson.vscode-markdownlint'
	'SonarSource.sonarlint-vscode'
	# Utils
	'donjayamanne.githistory'
	'GitHub.vscode-pull-request-github'
	'ms-vscode-remote.remote-wsl'
	'ms-vscode.PowerShell'
	'redhat.vscode-yaml'
	'christian-kohler.path-intellisense'
	'adpyke.codesnap'
	# Server Tools
	'ms-azuretools.vscode-docker'
	'ritwickdey.LiveServer'
	'ritwickdey.live-sass'
)

foreach ( $extension in $generalExtensions )
{
	Write-Output "> Installing $extension"
  code-insiders --install-extension $extension --force
}

Write-Output "Setting Up JS/TS Extensions"
$jsExtensions = @(
	# Base
	'christian-kohler.npm-intellisense'
	# Productivity Tools
	'xabikos.JavaScriptSnippets'
	'dsznajder.es7-react-js-snippets'
	# Linting
	'dbaeumer.vscode-eslint'
	'deque-systems.vscode-axe-linter'
)

foreach ( $extension in $jsExtensions )
{
	Write-Output "> Installing $extension"
  code-insiders --install-extension $extension --force
}

Write-Output "Setting Up Dot Net Extensions"
$jsExtensions = @(
	#	Base
	'ms-dotnettools.csdevkit'
	'ms-dotnettools.vscodeintellicode-csharp'
	# Productivity Tools
	'Fudge.auto-using'
)

foreach ( $extension in $jsExtensions )
{
	Write-Output "> Installing $extension"
  code-insiders --install-extension $extension --force
}

Write-Output "Setting Up Python Extensions"
$jsExtensions = @(
	#	Base
	'ms-python.python'
	'ms-python.vscode-pylance'
	'ms-toolsai.jupyter'
)

foreach ( $extension in $jsExtensions )
{
	Write-Output "> Installing $extension"
  code-insiders --install-extension $extension --force
}