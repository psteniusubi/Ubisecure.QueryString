Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop

BeforeAll {
    Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "../Ubisecure.QueryString.psd1" -Resolve -ErrorAction Stop) -Force -ErrorAction Stop
}

Describe "Add-QueryString" {
    It "KeyValue" {
        $t = New-QueryString | Add-QueryString -Key "key" -Value "value" 
        $t | Should -BeOfType [System.Collections.IDictionary]
        $t.Count | Should -Be 1
        $t | ConvertTo-QueryString | Should -BeExactly "key=value"
    }
    It "Values" {
        $t = New-QueryString | Add-QueryString -Values @{"key" = "value" }
        $t | Should -BeOfType [System.Collections.IDictionary]
        $t.Count | Should -Be 1
        $t | ConvertTo-QueryString | Should -BeExactly "key=value"
    }
    It "Duplicate" {
        $t = New-QueryString | Add-QueryString -Key "key" -Value "value" | Add-QueryString -Key "key" -Value "value"
        $t | Should -BeOfType [System.Collections.IDictionary]
        $t.Count | Should -Be 1
        $t | ConvertTo-QueryString | Should -BeExactly "key=value&key=value"
    }
    It "Tests" {
        New-QueryString | Add-QueryString @{"" = "value1" } | ConvertTo-QueryString | Should -Be "value1"

        New-QueryString | Add-QueryString @{"k" = $null } | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString @{"k" = "" } | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString @{"k" = @() } | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString @{"k" = @("") } | ConvertTo-QueryString | Should -Be "k="

        New-QueryString | Add-QueryString -Key $null value1 | ConvertTo-QueryString | Should -Be "value1"
        New-QueryString | Add-QueryString "" value1 | ConvertTo-QueryString | Should -Be "value1"

        New-QueryString | Add-QueryString k $null | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString k "" | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString k @() | ConvertTo-QueryString | Should -Be "k="
        New-QueryString | Add-QueryString k @("") | ConvertTo-QueryString | Should -Be "k="

        New-QueryString | Add-QueryString k value1 | ConvertTo-QueryString | Should -Be "k=value1"
        New-QueryString | Add-QueryString k value1, value2 | ConvertTo-QueryString | Should -Be "k=value1&k=value2"
    }
    It "Oidc" {
        $query = New-QueryString |
        Add-QueryString "response_type" "code" |
        Add-QueryString "client_id" "public" |
        Add-QueryString "scope" "openid" |
        Add-QueryString "redirect_uri" "http://localhost/public" |
        ConvertTo-QueryString
        $query | Should -Be "response_type=code&client_id=public&scope=openid&redirect_uri=http%3A%2F%2Flocalhost%2Fpublic"
    }
}
