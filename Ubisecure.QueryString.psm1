# module script files
$files = @(
    "private/IsEmpty.ps1"
    "private/ToString.ps1"
    "Add-QueryString.ps1"
    "ConvertFrom-QueryString.ps1"
    "ConvertTo-QueryString.ps1"
    "New-QueryString.ps1"
    "Select-QueryString.ps1"
)

# dot source script files
foreach ($i in $files) {
    $p = Join-Path -Path $PSScriptRoot -ChildPath $i -Resolve -ErrorAction Stop
    # $p | Write-Host -ForegroundColor Yellow
    . $p
}
