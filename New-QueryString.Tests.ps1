BeforeAll {
    Import-Module "$PSScriptRoot\Ubisecure.QueryString.psd1" -Force -ErrorAction Stop
}

Describe "New-QueryString" {
    It "IDictionary" {
        $t = New-QueryString
        $t | Should -BeOfType [System.Collections.IDictionary]
        $t.Count | Should -Be 0
        $t | ConvertTo-QueryString | Should -BeExactly ""
    }
    
}