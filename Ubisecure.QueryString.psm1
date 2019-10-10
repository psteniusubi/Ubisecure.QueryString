function New-QueryString {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
    )
    process {
        [System.Collections.Specialized.OrderedDictionary]::new()
    }
}

function IsEmpty {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [AllowNull()]
        [object]
        $InputObject
    )
    process {
        if($InputObject -eq $null) { return $true }
        if($InputObject -is [string]) { return $false }
        if($InputObject -is [System.Collections.IEnumerable]) { return -not $InputObject.GetEnumerator().MoveNext() }
        return $false
    }
}

function ToString {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object]
        $InputObject
    )
    process {
        if($InputObject -eq $null) { return }
        elseif($InputObject -is [string]) { return $InputObject }
        elseif($InputObject -is [System.Collections.IEnumerable]) { 
            foreach($i in $InputObject.GetEnumerator()) {
                $i | ToString
            }
            return
        }
        else { return $InputObject.ToString() }
    }
}

function Add-QueryString {
    [CmdletBinding(DefaultParameterSetName="KeyValue")]
    [OutputType([System.Collections.IDictionary])]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Collections.IDictionary]
        $InputObject = (New-QueryString),

        [parameter(Mandatory=$true,Position=1,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [Alias("Name")]
        [string]
        $Key,

        [parameter(Mandatory=$true,Position=2,ParameterSetName="KeyValue")]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [string[]]
        $Value,

        [parameter(Mandatory=$true,Position=1,ParameterSetName="Values")]
        [System.Collections.IDictionary]
        $Values
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            "KeyValue" {
                #Write-Host "Add-QueryString: '$Key'='$Value'"
                $list = [System.Collections.ArrayList]::new()
                if(-not (IsEmpty $InputObject[$Key])) {
                    $InputObject[$Key] | ToString | % { 
                        #Write-Host "InputObject: list.Add($_)"
                        $null = $list.Add($_) 
                    }
                }
                if(-not (IsEmpty $Value)) {
                    $Value | ToString | % { 
                        #Write-Host "Value: list.Add($_)"
                        $null = $list.Add($_) 
                    }
                }
                $InputObject[$Key] = $list
            }
            "Values" {
                foreach($kv in $Values.GetEnumerator()) {
                    $key = $kv.Key
                    $list = $kv.Value
                    if(IsEmpty $list) {
                        $list = @()
                    } else {
                        $list = $list | ToString 
                    }
                    $InputObject = $InputObject | Add-QueryString -Key $key -Value $list
                }
            }
        }
        $InputObject
    }
}

function ConvertTo-QueryString {
    [CmdletBinding(DefaultParameterSetName="IDictionary")]
    [OutputType([string])]
    param(
        [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="IDictionary")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory=$true,Position=0,ParameterSetName="NameValueCollection")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.Specialized.NameValueCollection]
        $NameValueCollection
    )
    begin {        
        $t = @()
    }
    process {
        if($InputObject -ne $null) { 
            foreach($kv in $InputObject.GetEnumerator()) {
                $key = $kv.Key
                $list = $kv.Value
                if(IsEmpty $list) {
                    $list = @( [string]::Empty )
                } else {
                    $list = $list | ToString 
                }
                foreach($value in $list) {
                    if([string]::IsNullOrEmpty($key)) {
                        #Write-Host "ConvertTo-QueryString: '$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($value) 
                    } else {
                        #Write-Host "ConvertTo-QueryString: '$key'='$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($key),[System.Net.WebUtility]::UrlEncode($value) -join "="
                    }
                }
            }
        }
        if($NameValueCollection -ne $null) { 
            foreach($key in $NameValueCollection.AllKeys) {
                $list = $NameValueCollection.GetValues($key)
                if(IsEmpty $list) {
                    $list = @( [string]::Empty )
                } else {
                    $list = $list | ToString 
                }
                foreach($value in $list) {
                    if([string]::IsNullOrEmpty($key)) {
                        #Write-Host "ConvertTo-QueryString: '$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($value) 
                    } else {
                        #Write-Host "ConvertTo-QueryString: '$key'='$value'"
                        $t += [System.Net.WebUtility]::UrlEncode($key),[System.Net.WebUtility]::UrlEncode($value) -join "="
                    }
                }
            }
        }
    }
    end {
        $t -join "&"
    }
}

function Select-QueryString {
    [CmdletBinding(DefaultParameterSetName="IDictionary")]
    [OutputType([string])]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="IDictionary")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary]
        $InputObject,

        [parameter(Mandatory=$true,ParameterSetName="NameValueCollection")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Collections.Specialized.NameValueCollection]
        $NameValueCollection,

        [parameter(Position=1,Mandatory=$true)]
        [Alias("Name")]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]
        $Key
    )
    process {
        if($InputObject -ne $null) { 
            $Key | ToString | % { 
                $list = $InputObject[$_] 
                if(IsEmpty $list) {
                    [string]::Empty
                } else {
                    $list
                }
            } | ToString 
        }
        if($NameValueCollection -ne $null) { 
            $Key | ToString | % { 
                $list = $NameValueCollection.GetValues($_)
                if(IsEmpty $list) {
                    [string]::Empty
                } else {
                    $list
                }
            } | ToString 
        }
    }
}

function ConvertFrom-QueryString {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
        [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $InputObject
    )
    begin {        
        $t = New-QueryString
    }
    process {
        if([string]::IsNullOrEmpty($InputObject)) { return }
        $InputObject = $InputObject -replace "^[^\?]*\?",""
        $InputObject -split "&" | % {
            if($_ -match "^([^=]*)(=(.*))?$") {
                $key = [System.Net.WebUtility]::UrlDecode($Matches[1])
                $value = [System.Net.WebUtility]::UrlDecode($Matches[3])
                #Write-Host "ConvertFrom-QueryString: Matches.Count = $($Matches.Count)"
                switch($Matches.Count) {
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
        $t
    }
}

