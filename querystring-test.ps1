Import-Module .\Ubisecure.QueryString.psd1 -Force

(New-QueryString | ConvertTo-QueryString) -eq ""
(@{} | ConvertTo-QueryString) -eq ""
($null | ConvertTo-QueryString) -eq ""
("" | ConvertFrom-QueryString | ConvertTo-QueryString) -eq ""
($null | ConvertFrom-QueryString | ConvertTo-QueryString) -eq ""

("k=" | ConvertFrom-QueryString | ConvertTo-QueryString) -eq "k="
("value1" | ConvertFrom-QueryString | ConvertTo-QueryString) -eq "value1"
("=value1" | ConvertFrom-QueryString | ConvertTo-QueryString) -eq "value1"

(@{""="value1"} | ConvertTo-QueryString) -eq "value1"

(@{"k"=$null} | ConvertTo-QueryString) -eq "k="
(@{"k"=""} | ConvertTo-QueryString) -eq "k="
(@{"k"=@()} | ConvertTo-QueryString) -eq "k="
(@{"k"=@("")} | ConvertTo-QueryString) -eq "k="
(@{"k"=@("","")} | ConvertTo-QueryString) -eq "k=&k="

(New-QueryString | Add-QueryString @{""="value1"} | ConvertTo-QueryString) -eq "value1"

(New-QueryString | Add-QueryString @{"k"=$null} | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString @{"k"=""} | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString @{"k"=@()} | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString @{"k"=@("")} | ConvertTo-QueryString) -eq "k="

(New-QueryString | Add-QueryString -Key $null value1 | ConvertTo-QueryString) -eq "value1"
(New-QueryString | Add-QueryString "" value1 | ConvertTo-QueryString) -eq "value1"

(New-QueryString | Add-QueryString k $null | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString k "" | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString k @() | ConvertTo-QueryString) -eq "k="
(New-QueryString | Add-QueryString k @("") | ConvertTo-QueryString) -eq "k="

(New-QueryString | Add-QueryString k value1 | ConvertTo-QueryString) -eq "k=value1"
(New-QueryString | Add-QueryString k value1,value2 | ConvertTo-QueryString) -eq "k=value1&k=value2"

(@{"k"=$null} | Select-QueryString k) -eq ""
(@{"k"=""} | Select-QueryString k) -eq ""

if($false) {
    Add-Type -AssemblyName System.Web
    $q = [System.Web.HttpUtility]::ParseQueryString("k1&k2=v1&k3")
    foreach($k in $q.Keys) {
        "key: $k ="
        foreach($v in $q.GetValues($k)) {
            "value: = $v"
        }
    }
    $q = [System.Web.HttpUtility]::ParseQueryString("k1=&k2=&k1=")
    foreach($k in $q.Keys) {
        "key: $k ="
        foreach($v in $q.GetValues($k)) {
            "value: = $v"
        }
    }
}
