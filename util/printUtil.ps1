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