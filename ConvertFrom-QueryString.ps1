function ConvertFrom-QueryString {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
        [parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $InputObject
    )
    begin {        
        $t = New-QueryString
    }
    process {
        if ([string]::IsNullOrEmpty($InputObject)) { return }
        $InputObject = $InputObject -replace "^[^\?]*\?", ""
        foreach ($kv in ($InputObject -split "&")) {
            if ($kv -match "^([^=]*)(=(.*))?$") {
                $key = [System.Net.WebUtility]::UrlDecode($Matches[1])
                $value = [System.Net.WebUtility]::UrlDecode($Matches[3])
                switch ($Matches.Count) {
                    2 { 
                        #Write-Host "ConvertFrom-QueryString: ''='$key'"
                        $t = $t | Add-QueryString -Key ([string]::Empty) -Value $key
                    }
                    4 { 
                        #Write-Host "ConvertFrom-QueryString: '$key'='$value'"
                        $t = $t | Add-QueryString -Key $key -Value $value
                    }
                }                
            }
        }
    }
    end {
        $PSCmdlet.WriteObject($t, $false)
    }
}
