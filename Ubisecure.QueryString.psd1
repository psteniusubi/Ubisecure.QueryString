#
# Module manifest for module "Ubisecure.QueryString"
#

@{
RootModule = "Ubisecure.QueryString.psm1"
ModuleVersion = "1.3.0"
GUID = "80f2f884-f2e3-457f-b7c2-16e884ce9ba2"
Author = "petteri.stenius@ubisecure.com"
Description = "QueryString utilities"
PowerShellVersion = "5.1"
CompatiblePSEditions = "Desktop","Core"
DefaultCommandPrefix = ""
FunctionsToExport = @(
    "Add-QueryString",
    "ConvertFrom-QueryString",
    "ConvertTo-QueryString",
    "New-QueryString",
    "Select-QueryString"
)
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
NestedModules = @()
}
