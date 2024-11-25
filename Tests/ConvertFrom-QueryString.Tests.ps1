BeforeAll {
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "../Ubisecure.QueryString.psd1" -Resolve -ErrorAction Stop) -Force -ErrorAction Stop
}

Describe "ConvertFrom-QueryString" {
    It "Empty" {
        "" | ConvertFrom-QueryString | ConvertTo-QueryString | Should -Be ""
        $null | ConvertFrom-QueryString | ConvertTo-QueryString | Should -Be ""
    }
    It "KeyOrValue" {
        "k=" | ConvertFrom-QueryString | ConvertTo-QueryString | Should -Be "k="
        "value1" | ConvertFrom-QueryString | ConvertTo-QueryString | Should -Be "value1"
        "=value1" | ConvertFrom-QueryString | ConvertTo-QueryString | Should -Be "value1"
    }
}
