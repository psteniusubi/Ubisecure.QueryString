BeforeAll {
    Import-Module "$PSScriptRoot\Ubisecure.QueryString.psd1" -Force -ErrorAction Stop
}

Describe "ConvertTo-QueryString" {
    It "Empty" {
        New-QueryString | ConvertTo-QueryString | Should -Be ""
        @{} | ConvertTo-QueryString | Should -Be ""
        $null | ConvertTo-QueryString | Should -Be ""
    }
    It "KeyOrValue" {
        @{""="value1"} | ConvertTo-QueryString | Should -Be "value1"
        @{"k"=$null} | ConvertTo-QueryString | Should -Be "k="
        @{"k"=""} | ConvertTo-QueryString | Should -Be "k="
        @{"k"=@()} | ConvertTo-QueryString | Should -Be "k="
        @{"k"=@("")} | ConvertTo-QueryString | Should -Be "k="
        @{"k"=@("","")} | ConvertTo-QueryString | Should -Be "k=&k="
    }
    It "Encoding" {
        New-QueryString | Add-QueryString "key" "+" | ConvertTo-QueryString | Should -Be "key=%2B"
    }
}
