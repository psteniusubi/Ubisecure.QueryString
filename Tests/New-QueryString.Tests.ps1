BeforeAll {
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "../Ubisecure.QueryString.psd1" -Resolve -ErrorAction Stop) -Force -ErrorAction Stop
}

Describe "New-QueryString" {
    It "IDictionary" {
        $t = New-QueryString
        $t | Should -BeOfType [System.Collections.IDictionary]
        $t.Count | Should -Be 0
        $t | ConvertTo-QueryString | Should -BeExactly ""
    }
    
}