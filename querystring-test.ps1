Import-Module Ubisecure.QueryString -Force

$m1 = @{"key1"="value1"} 
$m2 = @{"key2"=@("value1","value2")} 

$m1 | ConvertTo-QueryString
$m2 | ConvertTo-QueryString

New-QueryString | Add-QueryString -Values $m1 -Verbose | ConvertTo-QueryString
New-QueryString | Add-QueryString -Values $m2 -Verbose | ConvertTo-QueryString
New-QueryString | Add-QueryString -Name "key3" -Value "value1" | Add-QueryString -Name "key3" -Value "value2" | ConvertTo-QueryString
