BeforeAll {
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "../Ubisecure.QueryString.psd1" -Resolve -ErrorAction Stop) -Force -ErrorAction Stop
}

Describe "Select-QueryString" {
    It "Empty" {
        @{"k" = $null } | Select-QueryString k | Should -Be ""
        @{"k" = "" } | Select-QueryString k | Should -Be ""
    }    
}
