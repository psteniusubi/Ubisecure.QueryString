Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop

BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath "../private/ToString.ps1" -Resolve -ErrorAction Stop)
    . (Join-Path -Path $PSScriptRoot -ChildPath "../private/IsEmpty.ps1" -Resolve -ErrorAction Stop)
}

Describe "ToString" {
    It "Empty" {
        ToString $null | Should -BeNullOrEmpty
        IsEmpty $null | Should -BeTrue
        ToString @() | Should -BeNullOrEmpty
        IsEmpty @() | Should -BeTrue
        ToString @(@()) | Should -BeNullOrEmpty
        IsEmpty @(@()) | Should -BeTrue
        ToString @(@(@())) | Should -BeNullOrEmpty
        IsEmpty @(@(@())) | Should -BeTrue
    }
    It "Nested" {
        ToString @(@(1)) | Should -Be "1"
        IsEmpty @(@(1)) | Should -BeFalse
        ToString @(1, @("a", @("A", "B"), "b"), 2) | Should -Be @('1', 'a', 'A', 'B', 'b', '2')
        IsEmpty @(1, @("a", @("A", "B"), "b"), 2) | Should -BeFalse
    }
    It "Map" {
        ToString @{"key" = "value" } | Should -Be "[key, value]"
        IsEmpty @{"key" = "value" } | Should -BeFalse
    }
}
