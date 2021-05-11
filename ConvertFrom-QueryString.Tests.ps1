BeforeAll {
    Import-Module "$PSScriptRoot\Ubisecure.QueryString.psd1" -Force -ErrorAction Stop
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
