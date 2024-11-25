function ConvertTo-QueryString {
    [CmdletBinding(DefaultParameterSetName = "IDictionary")]
    [OutputType([string])]
    param(
        [parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "IDictionary")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory = $true, Position = 0, ParameterSetName = "NameValueCollection")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.Specialized.NameValueCollection]
        $NameValueCollection
    )
    begin {        
        $t = @()
    }
    process {
        if ($InputObject -ne $null) { 
            foreach ($kv in $InputObject.GetEnumerator()) {
                $key = $kv.Key
                $list = $kv.Value
                if (IsEmpty $list) {
                    $list = @( [string]::Empty )
                }
                else {
                    $list = ToString $list
                }
                foreach ($value in $list) {
                    if ([string]::IsNullOrEmpty($key)) {
                        #Write-Host "ConvertTo-QueryString: '$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($value) 
                    }
                    else {
                        #Write-Host "ConvertTo-QueryString: '$key'='$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($key), [System.Net.WebUtility]::UrlEncode($value) -join "="
                    }
                }
            }
        }
        if ($NameValueCollection -ne $null) { 
            foreach ($key in $NameValueCollection.AllKeys) {
                $list = $NameValueCollection.GetValues($key)
                if (IsEmpty $list) {
                    $list = @( [string]::Empty )
                }
                else {
                    $list = ToString $list
                }
                foreach ($value in $list) {
                    if ([string]::IsNullOrEmpty($key)) {
                        #Write-Host "ConvertTo-QueryString: '$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($value) 
                    }
                    else {
                        #Write-Host "ConvertTo-QueryString: '$key'='$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($key), [System.Net.WebUtility]::UrlEncode($value) -join "="
                    }
                }
            }
        }
    }
    end {
        $PSCmdlet.WriteObject(($t -join "&"), $false)        
    }
}
