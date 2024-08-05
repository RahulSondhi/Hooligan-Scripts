function Install-WinGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Extension,
        [Parameter()]
        [switch]$Upgrade
    )
    
    process {
        Write-SubHeader "Installing $Extension on Windows"

        if ( $Upgrade ) {
            winget install --id=$Extension --source=winget --exact --accept-source-agreements --accept-package-agreements --silent
        }
        else {
            winget install --id=$Extension --no-upgrade --source=winget --exact --accept-source-agreements --accept-package-agreements --silent
        }
    }
}

function Install-WSL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Extension,
        [Parameter()]
        [switch]$Upgrade
    )

    process {
        Write-SubHeader "Installing $Extension on WSL"

        wsl sudo apt update 

        if ( $Upgrade ) {
            wsl sudo apt upgrade $Extension -q -y
        }
        else {
            wsl sudo apt install $Extension -q -y
        }
    }
}