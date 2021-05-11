BeforeAll {
    Import-Module "$PSScriptRoot\Ubisecure.QueryString.psd1" -Force -ErrorAction Stop
}

Describe "Select-QueryString" {
    It "Empty" {
        @{"k"=$null} | Select-QueryString k | Should -Be ""
        @{"k"=""} | Select-QueryString k | Should -Be ""
    }    
}
